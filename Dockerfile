# Use the base image
FROM tiryoh/ros-desktop-vnc:noetic

# Limit the number of jobs, can be overloaded using the `--build-args num_jobs=N` commandline argument
ARG num_jobs=2
ARG CONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# Install VSCodium
RUN wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg && \
    echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | tee /etc/apt/sources.list.d/vscodium.list && \
    apt-get update -q && \
    apt-get install -y codium && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Install ROS dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    nano \
    ros-noetic-robot-localization* \
    ros-noetic-realsense* \
    ros-noetic-geodesy \
    ros-noetic-geographic-msgs \
    ros-noetic-costmap-2d \
    ros-noetic-octomap-msgs && \
    rm -rf /var/lib/apt/lists/*

# Clone course repo and rename the course origin as `course_repo`
WORKDIR /home/ubuntu/
RUN git clone https://gitlab.gbar.dtu.dk/dtu-asl/courses/34763-autonomous-marine-robotics && \
    cd 34763-autonomous-marine-robotics && git remote rename origin course_repo

# Build ROS workspace
RUN cd /home/ubuntu/34763-autonomous-marine-robotics/ros_ws && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make -j${num_jobs} -l${num_jobs}"

RUN python -m pip install --user scipy

# Add ROS workspace setup to .bashrc
RUN echo "source /home/ubuntu/34763-autonomous-marine-robotics/ros_ws/devel/setup.bash" >> /home/ubuntu/.bashrc

#####################
# Install miniconda #
#####################
# Install miniconda

ARG PATH="/root/miniconda3/bin:${PATH}"
ENV PATH="/root/miniconda3/bin:${PATH}"
RUN wget $CONDA_URL \
    && mkdir /root/.conda \
    && bash $(basename $CONDA_URL) -b \
    && rm -f $(basename $CONDA_URL)

#####################

# Fix permissions
RUN chown -R ubuntu:ubuntu /home/ubuntu/34763-autonomous-marine-robotics
