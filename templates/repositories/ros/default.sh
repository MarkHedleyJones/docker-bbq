#!/usr/bin/env bash

tag=${tag:-noetic-ros-base}

dockerfile_components=(
  base-header
  base-install-apt-packages
  base-install-pip-packages
  base-copy-local-resources
  base-create-user
  base-setup-workspace-vars
  ros/target-base-footer
  target-development
  ros/target-development-body
  target-preproduction
  ros/target-preproduction-body
  target-production
  target-production-body
)

makefile_components=(
  file-header
  buildstage-development
  buildstage-development-body
  buildstage-production
  buildstage-production-body
  buildstage-prebuild
  buildstage-prebuild-body
  ros/buildstage-prebuild
  buildstage-postbuild
  buildstage-postbuild-body
)

readme_components=(
  file-header
  section-building
  ros/section-development
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
