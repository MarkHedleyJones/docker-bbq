#!/usr/bin/env bash

repositories_dir="${BASEDIR}/templates/repositories"
base_dir=$(pwd)
for repository in $(ls ${repositories_dir}); do
  subheading "${repository} template"
  name="Create repository"
  pass 'create-repo "${repository}" test'

  cd test
  name="Build development image"
  pass 'make'

  name="Build production image"
  pass 'make production'

  name="System package installation"
  printf "htop\nranger" > build/packagelist
  pass make

  name="System packages installed"
  pass 'run ranger --help | grep "Usage: ranger"'

  name="Packagelist intact after build"
  pass 'cat build/packagelist | grep htop > /dev/null'
  echo "" > build/packagelist

  printf "pip-date\ntiny" > build/pip3-requirements.txt
  name="PIP package installation"
  pass make
  rm build/pip3-requirements.txt

  name="PIP package installed"
  pass 'run pip-date | grep "Done!"'

  base_url="https://raw.githubusercontent.com/MarkHedleyJones/docker-bbq/main"
  printf "${base_url}/LICENSE\n${base_url}/README.md\n" > build/urilist
  name="Downloading external URIs"
  pass make
  rm build/urilist

  name="Downloaded URI is in image"
  pass 'run "cat /build/resources/LICENSE | grep "MIT License" && \
            cat /build/resources/README.md | grep "# docker-bbq" && \
            /workspace/target.sh"'

  # Clean-up
  cd ${base_dir} && rm -rf test
done
