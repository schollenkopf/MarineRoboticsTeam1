#!/bin/bash
echo "Staring the build process, this might take a while..."

# Set the aarch64 platform
PLATFORM_FLAG="--build-arg CONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"

docker build -t dtu_34763_ros_image --build-arg num_jobs=2 $PLATFORM_FLAG -f Dockerfile .


echo "Creating container..."
docker create \
    -p 6080:80 \
    --shm-size=2048m \
    --privileged \
    -v ${PWD}/ros_ws/src:/home/ubuntu/34763-autonomous-marine-robotics/ros_ws/src:rw \
    -v ${PWD}/Training_Sessions:/home/ubuntu/34763-autonomous-marine-robotics/Training_Sessions:rw \
    --name dtu_34763 dtu_34763_ros_image

echo "Container created! Run the 'scripts/start_container.sh' script to start the container"