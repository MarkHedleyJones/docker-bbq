#!/usr/bin/env bash

tag=${tag:-noetic-ros-base}

dockerfile_componets=(
  file-header
  install-apt-packages
  target-development-head
  ros/target-development-body
  target-development-tail
  target-preproduction-head
  ros/target-preproduction-body
  target-preproduction-tail
  target-production-head
  target-production-body
  target-production-tail
)

makefile_componets=(
  file-header
  buildstage-development-head
  buildstage-development-body
  buildstage-development-tail
  buildstage-production-head
  buildstage-production-body
  buildstage-production-tail
  buildstage-prebuild-head
  ros/buildstage-prebuild-body
  buildstage-prebuild-tail
)

create_directories=(
  workspace/catkin_ws
  workspace/catkin_ws/src
)

dockerignore_entries=(
  workspace/catkin_ws/build
  workspace/catkin_ws/devel
  workspace/catkin_ws/install
)

gitignore_entries=(
  workspace/catkin_ws/build
  workspace/catkin_ws/devel
  workspace/catkin_ws/install
)
