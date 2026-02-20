#!/bin/bash
# ==========================================
# Hydra Workspace Build Script (ROS Noetic)
# Run this inside the container after mounting your workspace
# ==========================================
set -e

CATKIN_WS=~/catkin_ws

# Source ROS
source /opt/ros/noetic/setup.bash

# Setup workspace and clone Hydra
mkdir -p ${CATKIN_WS}/src
cd ${CATKIN_WS}/src
if [ ! -d "Hydra" ]; then
    git clone https://github.com/MIT-SPARK/Hydra.git Hydra
    cd Hydra && git checkout v1.0.0 && cd ..
fi

# Convert SSH URLs to HTTPS and import dependencies
sed 's|git@github.com:|https://github.com/|g' Hydra/install/hydra.rosinstall > /tmp/hydra_docker.rosinstall
vcs import . < /tmp/hydra_docker.rosinstall

# Initialize catkin workspace and configure build
cd ${CATKIN_WS}
catkin init
catkin config -DCMAKE_BUILD_TYPE=Release \
             -DGTSAM_TANGENT_PREINTEGRATION=OFF \
             -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF \
             -DOPENGV_BUILD_WITH_MARCH_NATIVE=OFF
catkin config --blacklist hdf5_map_io mesh_msgs_hdf5 label_manager \
                          mesh_tools rviz_map_plugin minkindr_python

# Install ROS dependencies via rosdep
sudo apt-get update
rosdep install --from-paths ${CATKIN_WS}/src --ignore-src -r -y
sudo rm -rf /var/lib/apt/lists/*

# Build
cd ${CATKIN_WS}
catkin build

echo ""
echo "Build complete. Source the workspace with:"
echo "  source ~/catkin_ws/devel/setup.bash"
