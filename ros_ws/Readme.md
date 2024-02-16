# Training Session 3 of Autonomous Marine Robotics Course (Path Planning using BlueROV Simulator)

## Getting Started

To begin with the training session, follow these steps:

1. Clone this repository to your local machine via terminal:

```bash
git clone https://github.com/yaqub93/bluerov_path_planning.git
```

2. Navigate to the cloned directory:

```bash
cd bluerov_path_planning
```

3. Run the docker installed during Training Session 1

```bash
docker run -it -v $PWD/:/home/ubuntu/course_ws -p 6080:80 --shm-size=512m ros_34763_v_1
```

4. Go to 127.0.0.1:6080

5. Open a new terminal, then:

   Install the dependencies:
```bash
sudo apt-get install ros-noetic-costmap-2d
sudo apt-get install ros-noetic-octomap-msgs
```

6. Compile the workspace:

```bash
cd course_ws
catkin_make
source devel/setup.bash
```

## Running:

1. Run the BlueROV Gazebo:
```bash
roslaunch bluerov2_gazebo start_pid_demo_lake.launch
```
2. Run the map publisher, path planner and path follower:
```bash
roslaunch bluerov_path_planning run.launch
```
3. Publish the goal position:
```bash
roslaunch bluerov_path_planning publish_goal.launch
```

## Contributing

If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.
