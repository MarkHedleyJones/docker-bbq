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

test_create_repository() {
  name="Create repository"
  pass 'create-repo "${repository}" ${TESTREPO}'
}

test_build_development_image() {
  cd ${TESTREPO}
  name="Build development image"
  pass 'make'
}

test_build_production_image() {
  name="Build production image"
  pass 'make production'
}

test_system_package_installation() {
  name="System package installation"
  printf "tinyproxy\nranger" > build/packagelist
  pass make
}

test_system_packages_installed() {
  name="System packages installed"
  pass 'run tinyproxy -v | grep "tinyproxy"'
}

test_packagelist_intact_after_build() {
  name="Packagelist intact after build"
  pass 'cat build/packagelist | grep tinyproxy > /dev/null'
  echo "" > build/packagelist
}

test_pip_package_installation() {
  printf "pip-date\ntiny" > build/pip3-requirements.txt
  name="PIP package installation"
  pass make
  rm build/pip3-requirements.txt
}

test_pip_package_installed() {
  name="PIP package installed"
  pass 'run pip-date | grep "Done!"'
}

test_downloading_external_uris() {
  base_url="https://raw.githubusercontent.com/MarkHedleyJones/docker-bbq/main"
  printf "${base_url}/LICENSE\n${base_url}/README.md\n" > build/urilist
  name="Downloading external URIs"
  pass make
  rm build/urilist
}

test_downloaded_uri_is_in_image() {
  name="Downloaded URI is in image"
  pass 'run "cat /build/resources/LICENSE | grep "MIT License" && \
            cat /build/resources/README.md | grep "# docker-bbq" && \
            /workspace/target.sh"'
}

test_build_with_non_root_user_account() {
  name="Build with non-root user account"
  pass 'USER_NAME=user make'
}

for repository in ${repositories[*]}; do
  subheading "${repository} template"
  test_create_repository
  test_build_development_image
  test_build_production_image
  test_system_package_installation
  test_system_packages_installed
  test_packagelist_intact_after_build
  test_pip_package_installation
  test_pip_package_installed
  test_downloading_external_uris
  test_downloaded_uri_is_in_image
  test_build_with_non_root_user_account

  # Clean-up
  cd ${base_dir} && rm -rf ${TESTREPO}

  # Run any tests defined in the template
  template_testscript="${repositories_dir}/${repository}/tests.sh"
  if [ -f ${template_testscript} ]; then
    source ${template_testscript}
    # Clean-up (again)
    cd ${base_dir} && rm -rf ${TESTREPO}
  fi
done
