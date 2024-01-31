# 34763 - Autonomous Marine Robotics

## Getting started with ROS Docker Image

Before building the ROS Docker image, make sure you have Docker installed on your system. If not, follow the instructions below to install Docker:

### Docker Installation:

1. **Linux:**
   - Follow the instructions on the [official Docker website](https://docs.docker.com/desktop/install/linux-install/) to install Docker on Linux.

2. **Windows:**
   - Download and install Docker Desktop from the [official Docker website](https://docs.docker.com/desktop/install/windows-install/).

3. **Mac:**
   - Download and install Docker Desktop from the [official Docker website](https://docs.docker.com/desktop/install/mac-install/).


### Clone the repository:

```bash
git clone https://gitlab.gbar.dtu.dk/dtu-asl/courses/34763-autonomous-marine-robotics.git
```

### Navigate to the Docker folder inside the cloned repository:

```bash
cd 34763-autonomous-marine-robotics/docker/noetic-minimum

```

### Build Instructions:

To build the Docker image, run the following command in the terminal:

```bash
docker build -t ros_34763_v_1 .
```

### Running the Docker Container:

To run the Docker container and access it through VNC, execute the following command:

```bash
docker run -p 6080:80 --shm-size=512m ros_34763_v_1
```

### Accessing VNC via Web Browser:

Once the Docker container is running, you can access the VNC server through your web browser using the following URL:

[http://127.0.0.1:6080/](http://127.0.0.1:6080/)


## Usage

Open terminal and do:

```bash
roslaunch bluerov2_gazebo start_pid_demo.launch
```
=======

