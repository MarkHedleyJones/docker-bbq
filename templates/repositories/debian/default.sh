#!/usr/bin/env bash

tag=${tag:-buster-slim}

dockerfile_componets=(
  file_header
  install_apt_packages
  development_target_head
  development_target_main
  development_target_tail
  pre_production_target_head
  pre_production_target_main
  pre_production_target_tail
  production_target_head
  production_target_main
  production_target_tail
)

makefile_componets=(
  file_header
  buildstage_development_head
  buildstage_development_main
  buildstage_development_tail
  buildstage_production_head
  buildstage_production_main
  buildstage_production_tail
  buildstage_prebuild_head
  buildstage_prebuild_main
  buildstage_prebuild_tail
)

directories=()

files=()

dockerignore=()

gitignore=()
