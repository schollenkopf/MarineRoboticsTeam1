# Use the base image
FROM tiryoh/ros-desktop-vnc:melodic


# Create and set up ROS workspace
RUN mkdir -p /home/ubuntu/catkin_ws/src
WORKDIR /home/ubuntu/catkin_ws/src
RUN git clone https://github.com/FletcherFT/bluerov2.git
RUN git clone https://github.com/FletcherFT/imc_ros_bridge.git

# Install ROS dependencies
RUN apt-get update && \
    apt-get install -y ros-melodic-geographic-info ros-melodic-mavros

# Install Python dependencies
RUN apt-get install -y python-pip && \
    python -m pip install --upgrade scipy

# Clone and build additional ROS package
RUN git clone https://github.com/uuvsimulator/uuv_simulator.git
RUN apt-get install -y ros-melodic-robot-localization*

# Add ROS workspace setup to .bashrc
RUN echo "source /home/ubuntu/catkin_ws/devel/setup.bash" >> /home/ubuntu/.bashrc

# Install Visual Studio Code
RUN apt-get install -y software-properties-common apt-transport-https wget && \
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" && \
    apt-get update && \
    apt-get install -y code

# Build ROS workspace
WORKDIR /home/ubuntu/catkin_ws
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin_make"