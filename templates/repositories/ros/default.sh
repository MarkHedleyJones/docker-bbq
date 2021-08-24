#!/usr/bin/env bash

workspace_name=catkin_ws

dockerfile_args=(
  APT_MIRROR,'""'
  BASE_IMAGE,ros:noetic-ros-base
  USER_NAME,root
  WORKSPACE_NAME,${workspace_name}
)

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
  ros/target-production-footer
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
  ${workspace_name}/src
)

dockerignore_entries=(
  ${workspace_name}/build
  ${workspace_name}/devel
  ${workspace_name}/install
)

gitignore_entries=(
  ${workspace_name}/build
  ${workspace_name}/devel
  ${workspace_name}/install
  ${workspace_name}/.catkin_workspace
  ${workspace_name}/src/CMakeLists.txt
)
