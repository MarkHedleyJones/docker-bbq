#!/usr/bin/env bash

tag=${tag:-buster-slim}

dockerfile_components=(
  file-header
  install-apt-packages
  install-pip-packages
  copy-local-resources
  create-user-account
  target-development
  target-development-body
  target-preproduction
  target-preproduction-body
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
  buildstage-postbuild
  buildstage-postbuild-body
)

readme_components=(
  file-header
  section-building
)

create_directories=()

dockerignore_lines=()

gitignore_lines=()
