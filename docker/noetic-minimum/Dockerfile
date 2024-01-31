# Use the base image
FROM tiryoh/ros-desktop-vnc:noetic

# Create and set up ROS workspace
RUN mkdir -p /home/ubuntu/course_ws/src
WORKDIR /home/ubuntu/course_ws/src
RUN git clone https://github.com/yaqub93/bluerov2.git
RUN git clone https://github.com/yaqub93/bluerov_simple_command.git

# Install ROS dependencies
RUN apt-get update

# Install Python dependencies
RUN apt-get install -y python3-pip nano
RUN python -m pip install --upgrade scipy

# Clone and build additional ROS package
RUN git clone https://github.com/arturmiller/uuv_simulator.git
RUN apt-get install -y ros-noetic-robot-localization*
RUN apt-get install -y ros-noetic-realsense*
RUN apt-get install -y ros-noetic-geodesy
RUN sudo apt-get install ros-noetic-geographic-msgs

# Build ROS workspace
WORKDIR /home/ubuntu/course_ws
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

# Add ROS workspace setup to .bashrc
RUN echo "source /home/ubuntu/course_ws/devel/setup.bash" >> /home/ubuntu/.bashrc

# Install Visual Studio Code
RUN apt-get install -y software-properties-common apt-transport-https wget && \
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" && \
    apt-get update && \
    apt-get install -y code

