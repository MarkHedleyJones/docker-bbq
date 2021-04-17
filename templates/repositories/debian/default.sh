#!/usr/bin/env bash

tag=${tag:-buster-slim}

dockerfile_componets=(
  file-header
  install-apt-packages
  install-pip-packages
  target-development-head
  target-development-body
  target-preproduction-head
  target-preproduction-body
  target-production-head
  target-production-body
)

makefile_componets=(
  file-header
  buildstage-development-head
  buildstage-development-body
  buildstage-production-head
  buildstage-production-body
  buildstage-prebuild-head
  buildstage-prebuild-body
  buildstage-postbuild-head
  buildstage-postbuild-body
)

readme_components=(
  file-header
  section-building
)

create_directories=()

dockerignore_lines=()

gitignore_lines=()
