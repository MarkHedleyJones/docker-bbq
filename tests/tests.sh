#!/usr/bin/env bash

path_run=NULL

run_test() {
  "${path_run}"/run "$@" > "${path_test_repo}"/log.txt
  if [[ "$(cat "${path_test_repo}/log.txt" | xargs)" =~ "SUCCESS" ]]; then
    echo "SUCCESS"
  else
    echo "FAILED"
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

echo "Running path resolution tests"

cd "${path_test_repo}" || exit 1
printf " - inside repo       ... "
run_test workspace/target.sh


cd "${path_test_repo}/workspace" || exit 1
printf " - inside workspace  ... "
run_test ./target.sh


cd "${path_test}" || exit 1
printf " - outside repo      ... "
run_test "${path_test_repo}"/workspace/target.sh
