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
  pass 'bbq-create "${repository}" ${TESTREPO}'
}

for repository in ${repositories[*]}; do
  subheading "${repository} template"

  # This test is compulsory - it creates the repository
  test_create_repository

  if [ -f "${repositories_dir}/${repository}/tests.sh" ]; then
    source "${repositories_dir}/${repository}/tests.sh"
  fi
  for test in ${template_tests[*]}; do
    cd ${TESTDIR}/${TESTREPO}
    source "${BASEDIR}/tests/definitions/templates/${test}"
  done

  # Clean-up
  cd ${base_dir} && rm -rf ${TESTREPO}
done
