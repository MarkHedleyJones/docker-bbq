#!/usr/bin/env bash

workspace_name=ros2_ws

dockerfile_args=(
  APT_MIRROR,'""'
  BASE_IMAGE,ros:jazzy-ros-base
  USER_GID,1000
  USER_UID,1000
  USER_NAME,user
  WORKSPACE_NAME,${workspace_name}
)

dockerfile_components=(
  base-header
  base-install-apt-packages
  ros2/base-install-pip-packages-ros2
  base-copy-local-resources
  ros2/base-create-user-ros2
  base-setup-workspace-vars
  ros2/target-base-footer
  target-development
  ros2/target-development-body
  target-preproduction
  ros2/target-preproduction-body
  target-production
  target-production-body
  ros2/target-production-footer
)

makefile_components=(
  file-header
  buildstage-development
  buildstage-development-body
  buildstage-production
  buildstage-production-body
  buildstage-prebuild
  buildstage-prebuild-body
  ros2/buildstage-prebuild
  buildstage-postbuild
  buildstage-postbuild-body
)

readme_components=(
  file-header
  section-building
  ros2/section-development
)

create_directories=(
  ${workspace_name}/src
)

dockerignore_entries=(
  ${workspace_name}/build
  ${workspace_name}/install
  ${workspace_name}/log
)

gitignore_entries=(
  ${workspace_name}/build
  ${workspace_name}/install
  ${workspace_name}/log
)