# Training Session 2 Solution

In this directory, you will find ROS workspace "ts2_ws". It contains ROS package named "ts2_record_data".

### Building the workspace

```
cd 34763-autonomous-marine-robotics\Training_Sessions\TS2_Models_from_Data\Solution\ts2_ws
catkin_make
source devel/setup.bash
```

### Run the simulator

Open the Gazebo, robot, controllers and visualizers
```
roslaunch ts2_record_data start_pid_demo.launch
```

Give command to the robot
```
roslaunch ts2_record_data forward_and_record.launch
```

You should find the bag file at: '34763-autonomous-marine-robotics/Training_Sessions/TS2_Models_from_Data/Solution/'

### Matlab section

1. Visualize the velocity, thrust force and estimate the body-fixed force using 'Training_session_2_visualize_bag.m' 
   The estimation is based on this [document](https://learn.inside.dtu.dk/d2l/common/dialogs/quickLink/quickLink.d2l?ou=187463&type=content&rcode=dtu-539439) from page 42
2. Do system identification using: 'Training_session_2_Model_learning_Surge.mlx' 


