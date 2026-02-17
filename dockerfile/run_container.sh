#!/bin/bash

# Allow X11 GUI apps (needed for rviz)
xhost +local:docker

# Define directories (update these to match your setup)
DATA_DIR="/home/$(id -un)/Documents/Hydra_Data"
WS_DIR="/home/$(id -un)/Documents/ros_workspaces/hydra_ws"

docker run -it \
    --name="hydra_noetic" \
    --shm-size=2gb \
    --gpus="all" \
    --network="host" \
    --privileged \
    --device /dev/dri \
    --workdir="/home/$USER/catkin_ws" \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="XAUTHORITY=/tmp/.Xauthority" \
    --env="XDG_RUNTIME_DIR=/tmp/runtime-$USER" \
    --volume="$DATA_DIR:/home/$USER/data:rw" \
    --volume="$WS_DIR:/home/$USER/catkin_ws:rw" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/tmp/runtime-$USER:/tmp/runtime-$USER" \
    --volume="$XAUTHORITY:/tmp/.Xauthority:ro" \
    hydra_noetic \
    /bin/bash
