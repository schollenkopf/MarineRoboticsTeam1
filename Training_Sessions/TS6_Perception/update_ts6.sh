
sudo apt-get install ros-noetic-aruco-detect -y
sudo apt-get install ros-noetic-aruco -y
sudo apt-get install ros-noetic-aruco-ros -y
sudo apt-get install ros-noetic-fiducial-slam -y

cd ts6_ws
catkin_make
source devel/setup.bash

MARKERS_PATH="$HOME/34763-autonomous-marine-robotics/Training_Sessions/TS6_Perception/ts6_ws/src/ts6_bluerov2_perception/markers"

grep -qxF "export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$MARKERS_PATH" $HOME/.bashrc
if [ $? -ne 0 ]; then
    echo "export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$MARKERS_PATH" >> $HOME/.bashrc
fi

TS6ROOT="$HOME/34763-autonomous-marine-robotics/Training_Sessions/TS6_Perception"

cmd="source $TS6ROOT/ts6_ws/devel/setup.bash"
grep -qxF "$cmd" $HOME/.bashrc
if [ $? -ne 0 ]; then
    echo "$cmd" >> $HOME/.bashrc
fi

source $HOME/.bashrc