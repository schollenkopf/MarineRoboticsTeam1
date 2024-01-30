# Use the base image
FROM tiryoh/ros-desktop-vnc:noetic

# Create and set up ROS workspace
RUN mkdir -p /home/ubuntu/course_ws/src
WORKDIR /home/ubuntu/course_ws/src
#RUN git clone https://github.com/FletcherFT/bluerov2.git
RUN git clone https://github.com/yaqub93/bluerov2.git
RUN git clone https://github.com/FletcherFT/imc_ros_bridge.git
RUN git clone https://github.com/yaqub93/bluerov_simple_command.git

# Install ROS dependencies
RUN apt-get update && \
    apt-get install -y ros-noetic-geographic-info ros-noetic-mavros
RUN apt-get install -y ros-noetic-realsense*

# Install Python dependencies
# RUN apt-get install -y python-pip && \
RUN python -m pip install --upgrade scipy

# Clone and build additional ROS package
RUN git clone https://github.com/arturmiller/uuv_simulator.git
RUN apt-get install -y ros-noetic-robot-localization*

# Add ROS workspace setup to .bashrc
RUN echo "source /home/ubuntu/course_ws/devel/setup.bash" >> /home/ubuntu/.bashrc

# Install Visual Studio Code
RUN apt-get install -y software-properties-common apt-transport-https wget && \
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" && \
    apt-get update && \
    apt-get install -y code

# Build ROS workspace
WORKDIR /home/ubuntu/course_ws
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

# Install Neptus and its dependencies
RUN sudo apt install -y openjdk-11-jdk
WORKDIR /home/ubuntu
RUN git clone https://github.com/LSTS/neptus.git
WORKDIR /home/ubuntu/neptus
RUN git checkout 38c7f41a9885c6b059f79b38861edb4b7b67511b
RUN /bin/bash -c "./gradlew"

# Install Ardupilot
WORKDIR /home/ubuntu
RUN git clone --recurse-submodules https://github.com/Ardupilot/ardupilot
WORKDIR /home/ubuntu/ardupilot
RUN /bin/bash -c "./waf configure --board sitl"
RUN /bin/bash -c "./waf sub"
RUN /bin/bash -c "./Tools/environment_install/install-prereqs-ubuntu.sh -y"
#RUN sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 2
# future should be 0.16.0


# Install Mavproxy
#RUN sudo apt-get install python3-dev python3-opencv python3-wxgtk4.0 python3-pip python3-matplotlib python3-lxml python3-pygame
#RUN pip3 install PyYAML mavproxy --user
#RUN echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc

RUN pip install PyYAML mavproxy --user
RUN ./sim_vehicle.py -v ArduSub -l 55.60304,12.808937,0,0 --out=tcp:172.31.144.1:14550 --map --console

RUN sudo apt-get install ros-noetic-geodesy
RUN sudo apt-get install ros-noetic-geographic-msgs

WORKDIR /opt/ros/noetic/lib/mavros
RUN /bin/bash -c "./install_geographiclib_datasets.sh"
RUN sudo apt-get install ros-noetic-joy

# run sitl
# roslaunch bluerov2_bringup bringup_ardusub_sitl.launch use_joystick:=false gazebo:=true

# Install QGroundcontrol
RUN sudo usermod -a -G dialout $USER
RUN sudo apt-get remove modemmanager -y
RUN sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
RUN sudo apt install libqt5gui5 -y
RUN sudo apt install libfuse2 -y
RUN sudo apt install fuse -y

#wget https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl.AppImage
# https://github.com/mavlink/qgroundcontrol/issues/10016

RUN mkdir -p /home/ubuntu/qgc
WORKDIR /home/ubuntu/qgc
RUN wget https://github.com/mavlink/qgroundcontrol/releases/download/v4.1.5/QGroundControl.AppImage
RUN chmod +x ./QGroundControl.AppImage
RUN sudo apt-get update && sudo apt-get -y --quiet --no-install-recommends install apt-utils binutils build-essential ca-certificates ccache checkinstall cmake curl espeak fuse g++ gcc git gosu kmod libespeak-dev libfontconfig1 libfuse2 libgstreamer-plugins-base1.0-dev libgstreamer1.0-0 libgstreamer1.0-dev libsdl2-dev libssl-dev libudev-dev locales make ninja-build openssh-client openssl patchelf pkg-config rsync speech-dispatcher wget xvfb zlib1g-dev 
