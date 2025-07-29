#!/usr/bin/env bash

tag=${tag:-latest}

dockerfile_args=(
  APT_MIRROR,'""'
  BASE_IMAGE,ubuntu:latest
  USER_GID,1000
  USER_UID,1000
  USER_NAME,user
  WORKSPACE_NAME,workspace
)

dockerfile_components=(
  base-header
  base-install-apt-packages
  ubuntu/base-install-pip-packages-ubuntu
  base-copy-local-resources
  base-create-user-ubuntu-style
  base-setup-workspace-vars
  target-development
  target-development-body
  target-preproduction
  target-preproduction-body
  target-production
  target-production-body
  target-production-footer
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
