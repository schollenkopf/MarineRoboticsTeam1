# Training Session 1 Solution

In this directory, you'll find the `square_wave_heading_command.py` file. Copy this file to the following location within the ROS workspace:

```
Training_Sessions\TS1_Introduction_to_Simulation\ts1_ws\src\ts1_simple_command\src
```

Additionally, you'll find the `CMakeLists.txt` file in this directory. Copy it to:

```
Training_Sessions\TS1_Introduction_to_Simulation\ts1_ws\src\ts1_simple_command
```

To rebuild the ROS workspace, please refer to the [following guide](./Training_Sessions/TS1_Introduction_to_Simulation/README.md#### Build the project) .

After rebuilding the workspace, proceed to run the simulator by following the instructions provided in the `Readme.md` file under the section labeled "Exercise 1 - Starting Simulation."

Finally, execute the Python program by running the command:

```
rosrun ts1_simple_command square_wave_surge_command.py
```

You should now observe your robot moving within Gazebo as expected.