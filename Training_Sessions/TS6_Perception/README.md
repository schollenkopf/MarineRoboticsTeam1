# TS6 Tutorial #

In this tutorial we'll explore how to utilize the perception system to improve robot localization.
We will compare the robot localization by only using the IMU and adding correction using AruCo markers.

## Pre-requisites ##

Update your docker workspace following [these instructions](https://gitlab.gbar.dtu.dk/dtu-asl/courses/34763-autonomous-marine-robotics/-/tree/main/#getting-course-updates).

## Setup ##

In your docker container workspace run the following (you should only have to run this once):

```
cd $HOME/34763-autonomous-marine-robotics/Training_Sessions/TS6_Perception
source update_ts6.sh
```

## Localization using IMU ###

# Start the simulator

With GUI:

```
roslaunch ts6_bluerov2_perception run.launch gui:=true fiducial_correction:=false
```

Without GUI:

```
roslaunch ts6_bluerov2_perception run.launch gui:=false fiducial_correction:=false
```

# Control the robot using keyboard:
```
roslaunch uuv_teleop uuv_keyboard_teleop.launch uuv_name:=bluerov2 
```

After controlling the robot for some time, you will notice that the estimated position will increasingly deviate from the ground truth.

Note on Rviz:
The red marker is the ground truth position.
The green marker is the estimated position

Debugging:
If you got errors that contains "\r", please go to this [following guide](https://gitlab.gbar.dtu.dk/dtu-asl/courses/34763-autonomous-marine-robotics/-/tree/main/debugging.md)

## Correction with AruCo markers ###

# Start the simulator
```
roslaunch ts6_bluerov2_perception run.launch gui:=false fiducial_correction:=true
```

# Control the robot using keyboard:
```
roslaunch uuv_teleop uuv_keyboard_teleop.launch uuv_name:=bluerov2 
```

Control the robot to a location where it cannot observe the AruCo markers for a period of time until the estimated position deviates. Then, guide the robot back to the area where it can detect the AruCo markers.