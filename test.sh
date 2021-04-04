#!/usr/bin/env bash

set -u

path_base="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" &> /dev/null && pwd -P)"
path_test="${path_base}/tests"
path_run="${path_base}/bin"

test_repo_name="test_repo"

test_templates="False"
if [[ " $* " =~ " --full " ]]; then
  test_templates="True"
fi

create_repo() {
  cd "${path_test}" || exit 1
  "${path_base}"/bin/create_docker_repo "$@" > /dev/null
  cd "$1" || exit 1
  # Add a success target to the workspace
  printf "#!/usr/bin/env sh\necho SUCCESS\n" > workspace/target.sh
  chmod +x workspace/target.sh
}

test_name=NULL

test() {
  printf " - "
  printf "%-31s" "${test_name}"
  printf " ... "
  if [[ $1 == "run" ]]; then
    shift
  else
    echo "Unknown test target - aborting"
    exit 1
  fi
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
    echo "run $*"
    echo ""
    echo -e "\e[33mDEBUG ENABLED EXECUTION:\e[0m"
    TESTING=1 "${path_run}"/run "$@"
    exit 1
  fi
}

cleanup() {
  docker image rm "${test_repo_name}" > /dev/null
  rm -rf "${path_test}"
}

cd "${path_base}" || exit 1
if [[ -d "${path_test}" ]]; then
  rm -rf "${path_test}"
fi
mkdir "${path_test}"
create_repo "${test_repo_name}" "default"

################################################################################
# Test definitions
################################################################################

# BASIC TESTING OF 'RUN' COMMAND
echo "Testing 'run' command on non-production image:"
cd "${path_test}/${test_repo_name}" || exit 1
make > /dev/null

test_name="inside repo, outside workspace"
cd "${path_test}/${test_repo_name}" || exit 1
test run workspace/target.sh

test_name="inside repo, inside workspace"
cd "${path_test}/${test_repo_name}/workspace" || exit 1
test run ./target.sh

test_name="outside repo, single command"
cd "${path_test}" || exit 1
test run "${test_repo_name}"/workspace/target.sh

test_name="outside repo, split command"
cd "${path_test}" || exit 1
test run "${test_repo_name}" /workspace/target.sh

echo ""

# Setup for testing production image
echo "Testing 'run' command on production image:"
cd "${path_test}/${test_repo_name}" || exit 1
make production > /dev/null

test_name="outside repo, single command"
cd /tmp || exit 1
test run "${path_test}/${test_repo_name}"/workspace/target.sh

test_name="outside repo, split command"
cd /tmp || exit 1
test run "${path_test}/${test_repo_name}" /workspace/target.sh

echo ""

if [[ "${test_templates}" == "False" ]]; then
  echo "Basic tests passed"
  cleanup
  exit 0
fi

################################################################################

# TESTING OF TEMPLATES

echo "Testing template repositories:"
cd "${path_test}" || exit 1 && rm -rf "${test_repo_name}"

test_name="ros: non-production image"
create_repo "${test_repo_name}" "ros"
make > /dev/null
cd "${path_test}/${test_repo_name}" || exit 1
test run workspace/target.sh

test_name="ros: production image"
make production > /dev/null
cd "${path_test}" || exit 1
test run "${test_repo_name}" /workspace/target.sh

echo ""

echo "All tests passed"
cleanup

