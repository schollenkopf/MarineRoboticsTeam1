sudo apt update
sudo apt remove default-jre
sudo apt install openjdk-11-jdk gnome-terminal
git clone https://github.com/LSTS/neptus.git
cd neptus
git checkout 38c7f41a9885c6b059f79b38861edb4b7b67511b
./gradlew
cd ../ts5_ros_ws/
catkin_make
source devel/setup.bash
TS5ROOT="$HOME/34763-autonomous-marine-robotics/Training_Sessions/TS5_Mission_Planning"

cmd="source $TS5ROOT/ts5_ros_ws/devel/setup.bash"
grep -qxF "$cmd" $HOME/.bashrc
if [ $? -ne 0 ]; then
    echo "$cmd" >> $HOME/.bashrc
fi
roscp bluerov2_neptus 00-bluerov2-1.nvcl $HOME/34763-autonomous-marine-robotics/Training_Sessions/TS5_Mission_Planning/neptus/vehicles-defs/.
cd ..
grep -qxF "export PATH=$TS5ROOT/neptus:\$PATH" $HOME/.bashrc
if [ $? -ne 0 ]; then
    echo "export PATH=$TS5ROOT/neptus:\$PATH" >> $HOME/.bashrc
fi
source $HOME/.bashrc