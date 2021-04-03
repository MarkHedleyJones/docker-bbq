#!/usr/bin/env bash

path_run=NULL

run_test() {
  printf " - "
  printf "%-31s" "${1}"
  printf " ... "
  shift
  "${path_run}"/run "$@" > "${path_test}"/log.txt
  if [[ "$(cat "${path_test}/log.txt" | xargs)" =~ "SUCCESS" ]]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILED\e[0m"
    echo ""
    echo -e "\e[33mERROR MESSAGE:\e[0m"
    cat "${path_test}"/log.txt
    echo ""
    echo -e "\e[33mFAILING COMMAND:\e[0m"
    echo "run $@"
    echo ""
    echo -e "\e[33mDEBUG ENABLED EXECUTION:\e[0m"
    TESTING=1 "${path_run}"/run "$@"
    exit 1
  fi
}

if [[ $# -eq 3 ]]; then
  path_test="$1"
  path_run="$(cd "${path_test}" && cd ../bin && pwd)"
  repo_lite_name="$2"
  repo_production_name="$3"
  path_repo_lite="${path_test}/${repo_lite_name}"
  path_repo_production="${path_test}/${repo_production_name}"
else
  echo "This file should be run by the 'run_tests.sh' script."
fi

########################
# Test definitions
########################

echo "Running path resolution tests:"

# Setup by moving to a location
# Then run the test by passing a name and expected command

cd "${path_repo_lite}" || exit 1
run_test "inside lite repo, outside workspace" workspace/target.sh

cd "${path_repo_lite}/workspace" || exit 1
run_test "inside lite repo, inside workspace" ./target.sh

cd "${path_test}" || exit 1
run_test "outside lite repo, single command" "${path_repo_lite}"/workspace/target.sh

cd "${path_test}" || exit 1
run_test "outside lite repo, split command" "${path_repo_lite}" /workspace/target.sh

cd / || exit 1
run_test "production image's workspace" "${path_repo_production}" /workspace/target.sh

echo "All tests passed"
