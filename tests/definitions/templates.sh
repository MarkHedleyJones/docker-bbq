#!/usr/bin/env bash

repositories_dir="${BASEDIR}/templates/repositories"
base_dir=$(pwd)

if [ ${test_template} == NULL ]; then
  repositories=($(ls ${repositories_dir}))
else
  if [ ! -d "${BASEDIR}/templates/repositories/${test_template}" ]; then
    echo "Error: No template named ${test_template}"
    exit 1
  fi
  repositories=(${test_template})
fi

for repository in ${repositories[*]}; do
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
  pass 'run ranger --version | grep "ranger version: ranger"'

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

  # Run any tests defined in the template
  template_testscript="${repositories_dir}/${repository}/tests.sh"
  if [ -f ${template_testscript} ]; then
    source ${template_testscript}
    # Clean-up (again)
    cd ${base_dir} && rm -rf test
  fi
done
