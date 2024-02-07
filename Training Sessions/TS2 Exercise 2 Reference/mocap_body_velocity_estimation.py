from matplotlib import pyplot as plt
import pandas as pd
from pathlib import Path
import rosbag
import numpy as np
from scipy.spatial.transform import Rotation
from scipy.io import savemat
from sklearn.linear_model import LinearRegression
import argparse


def interp(df, new_index):
    """Return a new DataFrame with all columns values interpolated
    to the new_index values."""
    df_out = pd.DataFrame(index=new_index)
    df_out.index.name = df.index.name

    for colname, col in df.iteritems():
        df_out[colname] = np.interp(new_index, df.index, col)

    return df_out


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("bag", help="Path to the .bag file containing PoseStamped data.")
    parser.add_argument("topic", help="topic containing PoseStamped data.")
    parser.add_argument("-r", "--resample_period", default="100L", help="Period to resample data across, default is 100L = 100 ms = 10 Hz.")
    args = parser.parse_args()
    path = Path(args.bag).resolve()
    assert path.exists(), f"Path {str(path)} not found."

    # First, accumulate pose data into a pandas DataFrame object
    data = []
    headers = ["timestamp", "x", "y", "z", "qx", "qy", "qz", "qw"]
    with rosbag.Bag(str(path)) as bag:
        for topic, msg, save_time in bag.read_messages(topics=[args.topic]):
            msg.header.stamp.to_sec()
            data.append([msg.header.stamp.to_time(), msg.pose.position.x, msg.pose.position.y, msg.pose.position.z,
                         msg.pose.orientation.x, msg.pose.orientation.y, msg.pose.orientation.z,
                         msg.pose.orientation.w])
    df = pd.DataFrame(data=data, columns=headers, dtype=np.double)

    # Convert timestamp into seconds since unix epoch, and use as index
    epoch = pd.Timestamp(year=1970, month=1, day=1)
    df['timestamp'] = pd.to_datetime(df['timestamp'], unit='s') - epoch
    df = df.set_index("timestamp")

    # Plot the position so we can see what we're working with.
    fig0, ax0 = plt.subplots()
    df[['x', 'y', 'z']].plot(ax=ax0, marker='x')

    # Extract time and x, y, z coordinates in the world frame
    t = df.index.to_series().dt.total_seconds().to_numpy()
    xyz = df[['x', 'y', 'z']].to_numpy()
    # Calculate the velocity via central difference gradient
    velocity, _ = np.gradient(xyz, t, np.arange(3))

    # The timestamps obtained from the mocap vrpn client are generated when a pose message is received from the mocap system.
    # This does not account for network lag and buffering, so the timestamps are clustered into tight groupings, the total time is pretty much the same.
    # The spacing is much smaller than the expected 100 Hz signal, which results in extremely large velocities.
    # To get around this we have to resample the signal.

    # First, just remap the timestamps with 10 ms (100 Hz) spacing
    newindex = pd.to_timedelta(np.arange(pd.Timedelta(0), pd.Timedelta(seconds=df.shape[0] * 0.01), pd.Timedelta(milliseconds=10)))
    t_reindex = newindex.total_seconds().to_numpy()
    xyz_reindex = xyz.copy()
    velocity_reindex, _ = np.gradient(xyz_reindex, t_reindex, np.arange(3))

    # Second, try interpolation
    newindex = pd.to_timedelta(np.arange(df.index[0], df.index[-1], pd.Timedelta(milliseconds=10)))
    interpolated = interp(df, newindex)
    t_interpolated = interpolated.index.to_series().dt.total_seconds().to_numpy()
    xyz_interpolated = interpolated[['x', 'y', 'z']].to_numpy()
    velocity_interpolated, _ = np.gradient(xyz_interpolated, t_interpolated, np.arange(3))

    # Third, try mean resampling across 100 ms sample bins
    resampled = df.resample(args.resample_period).mean().interpolate()
    xyz_resampled = resampled[['x', 'y', 'z']].to_numpy()
    t_resampled = resampled.index.to_series().dt.total_seconds().to_numpy()
    velocity_resampled, _ = np.gradient(xyz_resampled, t_resampled, np.arange(3))

    # Fourth, try fitting the time with linear regression
    X = np.arange(df.shape[0])[:, None]
    y = df.index.to_series().dt.total_seconds().to_numpy()[:, None]
    lr = LinearRegression()
    lr.fit(X, y)
    y_hat = lr.predict(X)
    velocity_lr, _ = np.gradient(xyz, y_hat.squeeze(), np.arange(3))

    # Plot the results, in our case it looks like mean resampled did the best job.
    fig1, ax1 = plt.subplots(5, 1)
    ax1[0].plot(velocity, marker='x')
    ax1[1].plot(velocity_reindex, marker='x')
    ax1[2].plot(velocity_interpolated, marker='x')
    ax1[3].plot(velocity_resampled, marker='x')
    ax1[4].plot(velocity_lr, marker='x')

    # Resample the Quaternions, get the rotation matrix, apply the transpose to get body-fixed velocity measurements.
    R_body_map = Rotation.from_quat(resampled[['qx','qy','qz','qw']]).as_matrix()
    R_map_body = R_body_map.transpose([0, 2, 1])
    euler_map_body = np.unwrap(Rotation.from_quat(resampled[['qx','qy','qz','qw']]).inv().as_euler('xyz'), axis=0)
    euler_velocity_resampled, _ = np.gradient(euler_map_body, t_resampled, np.arange(3))
    uvw = R_map_body @ velocity_resampled[..., None]
    fig2, ax2 = plt.subplots(2, 1)
    ax2[0].plot(uvw.squeeze(), marker='x')
    ax2[1].plot(euler_velocity_resampled.squeeze(), marker='x')
    savemat(str(path.with_name(path.stem + "_mocap_velocity_estimates.mat")),
            mdict={"unix_seconds": t_resampled[:, None],
                   "linear_velocity": uvw,
                   "angular_velocity": euler_velocity_resampled})
    plt.show()

if __name__=="__main__":
    main()


