#!/usr/bin/env bash

dockerfile_args=(
  APT_MIRROR,'""'
  BASE_IMAGE,debian:buster-slim
  USER_GID,1000
  USER_UID,1000
  USER_NAME,user
  WORKSPACE_NAME,workspace
)

dockerfile_components=(
  base-header
  base-install-apt-packages
  base-install-pip-packages
  base-copy-local-resources
  base-create-user
  base-setup-workspace-vars
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
