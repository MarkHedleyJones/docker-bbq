#!/usr/bin/env bash

tag=${tag:-buster-slim}

dockerfile_componets=(
  header
  install_apt_packages
  production_target
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
  buildstage_prebuild_main
  buildstage_prebuild_tail
)

directories=()

files=()

dockerignore=()

gitignore=()
