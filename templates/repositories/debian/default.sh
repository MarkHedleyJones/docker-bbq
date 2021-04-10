#!/usr/bin/env bash

tag=${tag:-buster-slim}

dockerfile_componets=(
  file-header
  install-apt-packages
  target-development-head
  target-development-body
  target-development-tail
  target-preproduction-head
  target-preproduction-body
  target-preproduction-tail
  target-production-head
  target-production-body
  target-production-tail
)

makefile_componets=(
  file-header
  buildstage-development-head
  buildstage-development-body
  buildstage-development-tail
  buildstage-production-head
  buildstage-production-body
  buildstage-production-tail
  buildstage-prebuild-head
  buildstage-prebuild-body
  buildstage-prebuild-tail
)

directories=()

files=()

dockerignore=()

gitignore=()
