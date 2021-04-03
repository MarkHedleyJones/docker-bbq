#!/usr/bin/env bash

path_run=NULL

run_test() {
  printf " - "
  printf "%-30s" "${1}"
  printf " ... "
  shift
  "${path_run}"/run "$@" > "${path_test_repo}"/log.txt
  if [[ "$(cat "${path_test_repo}/log.txt" | xargs)" =~ "SUCCESS" ]]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILED\e[0m"
    echo ""
    echo "Command: run $@"
    echo "Error:"
    cat "${path_test_repo}"/log.txt
    exit 1
  fi
}

if [[ $# -eq 2 ]]; then
  path_test=$1
  path_run="$(cd "${path_test}" && cd ../bin && pwd)"
  dirname_test_repo=$2
  path_test_repo="${path_test}/${dirname_test_repo}"
else
  echo "This file should be run by the 'run_tests.sh' script."
fi

########################
# Test definitions
########################

echo "Running path resolution tests"

# Setup by moving to a location
# Then run the test by passing a name and expected command

cd "${path_test_repo}" || exit 1
run_test "inside repo, outside workspace" workspace/target.sh

cd "${path_test_repo}/workspace" || exit 1
run_test "inside repo, inside workspace" ./target.sh

cd "${path_test}" || exit 1
run_test "outside repo" "${path_test_repo}"/workspace/target.sh
