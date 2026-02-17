# ================================
# ROS Noetic + Hydra Docker
# ================================

FROM osrf/ros:noetic-desktop

# Set user arguments (being username, echo $UID, and id -g)
# NOTE: These should be overwritten when running docker build!
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=1000

# Remove the default ubuntu user if it exists
RUN userdel -r ubuntu 2>/dev/null || true && \
    groupdel ubuntu 2>/dev/null || true

# Create a non-root user with matching UID/GID
RUN groupadd --force --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} && \
    usermod -aG sudo ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Add a custom .bashrc with warm colors and fixed hostname
RUN echo 'export PS1="\\[\\e[1;31m\\]\\u@hydra_container\\[\\e[0m\\]:\\[\\e[1;33m\\]\\w\\[\\e[0m\\]\\$ "' > /home/${USERNAME}/.bashrc && \
    chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bashrc

# Set default user
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Install required packages
ENV DEBIAN_FRONTEND=noninteractive
ARG CATKIN_WS=/home/${USERNAME}/catkin_ws
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    # Core Build Tools
    build-essential \
    cmake \
    git \
    curl \
    wget \
    ccache \
    vim \
    htop \
    net-tools \
    # Python & ROS Build Tools
    python3-pip \
    python3-setuptools \
    python3-dev \
    python3-catkin-tools \
    python3-vcstool \
    python3-rosdep \
    # Hydra C++ Dependencies
    libprotobuf-dev \
    protobuf-compiler \
    # Debugging
    ros-noetic-rqt-graph \
    ros-noetic-rqt-tf-tree \
    && sudo rm -rf /var/lib/apt/lists/*

# Default shell
SHELL ["/bin/bash", "-c"]

# Set the User environment variables
RUN echo "export USER=${USERNAME}" >> ~/.bashrc

# Source ROS setup.bash and initialize rosdep
RUN sudo rosdep init || true && rosdep update
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

# Enable ccache for faster rebuilds
RUN echo 'export PATH="/usr/lib/ccache:$PATH"' >> ~/.bashrc && \
    ccache --max-size=20G

# Install tmux and tmuxp
RUN sudo apt-get update && sudo apt-get install -y tmux tmuxp && \
    sudo rm -rf /var/lib/apt/lists/*
RUN touch ~/.tmux.conf && \
    echo "set -g mouse on" >> ~/.tmux.conf

# Source workspace if it exists, and add convenience alias
RUN echo '[ -f ~/catkin_ws/devel/setup.bash ] && source ~/catkin_ws/devel/setup.bash' >> ~/.bashrc && \
    echo "alias cb='cd ~/catkin_ws && catkin build'" >> ~/.bashrc

# Set the workspace directory
WORKDIR ${CATKIN_WS}
