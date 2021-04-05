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
  buildstage_basic
  buildstage_production
  ros/makefile_prebuild
)

directories=(
  workspace
  workspace/src
)

files=(
  packagelist
  workspace/src/.docker-flow
)

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
