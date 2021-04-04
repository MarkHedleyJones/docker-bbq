#!/usr/bin/env bash

tag=${tag:-buster-slim}

dockerfile_componets=(
  header
  install_apt_packages
  production_target
)

makefile_componets=(
  header
  buildstage_basic
  buildstage_production
  buildstage_prebuild
)

directories=(
  workspace
)

files=(
  packagelist
)
