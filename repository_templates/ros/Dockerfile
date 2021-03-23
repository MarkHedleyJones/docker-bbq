ARG BASE_REPO
ARG BASE_TAG

# The base image is passed in from the Makefile
FROM $BASE_REPO:$BASE_TAG

# Allow the workspace variable to be used during build
ARG WORKDIR

# Install required packages for this project
# RUN apt-get update \
#   && apt-get install --yes --no-install-recommends \
#     ... \
#   && echo "Workspace package(s) installed."

# Run any configuration or build tasks here

WORKDIR $WORKDIR

# Convenience function to set ownership of paths within workspace to host user
RUN echo """#!/usr/bin/env bash\n\
chown --recursive --from=\$(id -u):\$(id -g) $(id -u):$(id -g) ${WORKDIR}\n\
""" > /usr/local/bin/fix-permissions \
    && chmod +x /usr/local/bin/fix-permissions

# Add ROS specific convenience functionality to the created image...
# Build & source the catkin workspace from anywhere by typing 'cm'
RUN echo """alias cm='cd ${WORKDIR} && catkin_make -j$(nproc) && rospack profile && source devel/setup.bash ; cd - > /dev/null'""" >> /root/.bashrc
# Ensure ros and the workspace environment is sourced even on docker exec
RUN echo """source /opt/ros/${ROS_DISTRO}/setup.bash""" >> /root/.bashrc
RUN echo """if [[ -f /workspace/devel/setup.bash ]]; then\n\
source /workspace/devel/setup.bash\n\
fi""" >> /root/.bashrc
