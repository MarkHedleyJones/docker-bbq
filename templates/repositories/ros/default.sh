#!/usr/bin/env bash

tag=${tag:-noetic-ros-base}

dockerfile_componets=(
  header
  install_apt_packages
  ros/dockerfile_extras
  production_target
  ros/dockerfile_production_build
)

makefile_componets=(
  header
  buildstage_development_head
  buildstage_development_main
  buildstage_development_tail
  buildstage_production_head
  buildstage_production_main
  buildstage_production_tail
  buildstage_prebuild_head
  ros/makefile_prebuild_main
  buildstage_prebuild_tail
)

directories=(
  workspace
  workspace/src
)

files=()

dockerignore=(
  workspace/build
  workspace/devel
  workspace/install
)

gitignore=(
  workspace/build
  workspace/devel
  workspace/install
)
