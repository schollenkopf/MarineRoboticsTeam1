# Training Session 3 Solution

## Exercise 2.1
See: 'exe2_1_sampling_based.ipynb'

## Exercise 2.2
See: 'exe2_2_sampling_based_seachart.ipynb'

## Exercise 3.2
You can find a new ROS workspace in Solution folder: 'ts3_ws'
There are new files:
1. astar_planner.py
2. run_astar.launch

### Building the workspace

```
cd 34763-autonomous-marine-robotics\Training_Sessions\TS3_Path_Planning\Solution\ts3_ws
catkin_make
source devel/setup.bash
```

### Run the simulator

Open the Gazebo, robot, controllers and visualizers
```
roslaunch bluerov2_gazebo start_pid_demo_lake.launch
```

Run the map publisher, path planner and path follower:
```
roslaunch ts3_path_planning run_astar.launch
```

Publish the goal position
```
roslaunch ts3_path_planning publish_goal.launch
```

## Exercise 4.1
See: 'exe4_1_sampling_based.ipynb'

## Exercise 4.2: 
Under construction...

Open the Gazebo, robot, controllers and visualizers
```
roslaunch bluerov2_gazebo start_pid_demo_lake.launch
```

Publish the octomap:
```
rosrun octomap_server octomap_server_node /home/ubuntu/34763-autonomous-marine-robotics/ros_ws/src/grid_map/grid_map_pcl/data/input_cloud.bt _frame_id:=map
```

Run the path planner and path follower:
```
roslaunch ts3_path_planning run_3d.launch
```

Publish the goal position
```
roslaunch ts3_path_planning publish_goal.launch
```