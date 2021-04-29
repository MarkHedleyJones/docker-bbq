#!/usr/bin/env bash

set -u

width_of_test_titles=40

BASEDIR="$( cd "$( dirname "$(dirname "${BASH_SOURCE[0]}")")" >/dev/null 2>&1 && pwd )"
TESTDIR="/tmp/docker-bbq/temporary"
DEBUG=0

test_sequence=(
  create-repo.sh
  building-repositories.sh
  run-command.sh
)

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [options]

  Run the standard test-suit on docker-bbq

OPTIONS:

  -h, --help       Print this help and exit
  -v, --verbose    Print debug information on test failure
  -a, --all        Run standard and template repository tests
  -t, --templates  Run only the template reposistory tests
EOF
  exit
}

if [[ " --help " =~ " $* " ]] || [[ " -h " =~ " $* " ]]; then
  usage
fi

if [[ " --verbose " =~ " $* " ]] || [[ " -v " =~ " $* " ]]; then
  DEBUG=1
fi

if [[ " --templates " =~ " $* " ]] || [[ " -t " =~ " $* " ]]; then
  test_sequence=(templates.sh)
fi

if [[ " --all " =~ " $* " ]] || [[ " -a " =~ " $* " ]]; then
  test_sequence+=(templates.sh)
fi


# The following variables are available to testfiles
export TESTDIR

# Override locations to remove need for installation before test
create-repo() {
  echo "${BASEDIR}/bin/create-repo $*"
  "${BASEDIR}/bin/create-repo" $*
}

run() {
 "${BASEDIR}/bin/run" $*
}

expected_return_code=NULL
num_tests_subtotal=0
passed_tests_subtotal=0
num_tests_total=0
passed_tests_total=0
heading_spacer=""
subheading_spacer=""

heading() {
  printf "${heading_spacer}"
  heading_spacer='\n'
  echo $1
}

subheading() {
  printf "${subheading_spacer}"
  subheading_spacer='\n'
  echo " * ${1^^}:"
}

run_test() {
  if [ "${name}" == NULL ]; then
    exit "Test does not have a name!"
    exit 1
  fi
  printf " - "
  printf "%-${width_of_test_titles}s" "${name}"
  printf " ... "
  eval "$*" > "${TESTDIR}/output" 2>&1
  local return_code=$?
  if [ "${return_code}" == "${expected_return_code}" ] ; then
    echo -e "\e[32mSUCCESS\e[0m"
    ((passed_tests_subtotal=passed_tests_subtotal+1))
    local success=1
  else
    echo -e "\e[31mFAILED!\e[0m"
    local success=0
  fi
  ((num_tests_subtotal=num_tests_subtotal+1))
  name=NULL
  output=$(cat "${TESTDIR}/output")
  if [ ${success} -eq 0 ] && [ ${DEBUG} -eq 1 ]; then
    if [ -s "${TESTDIR}/output" ]; then

      printf "\n######### DEBUG OUTPUT FROM FAILED TEST START #########\n"
      cat "${TESTDIR}/output"
      printf "########## DEBUG OUTPUT FROM FAILED TEST END ##########\n\n"
    else
      echo "   FAILED TEST PRODUCED NO DEBUG OUTPUT"
    fi
  fi
  return ${success}
}

pass() {
  expected_return_code=0
  run_test $*
  return $?
}

fail() {
  expected_return_code=1
  run_test $*
  return $?
}

# Ensure there are no containers running from abandoned tests
docker rm /test-latest > /dev/null 2>&1
# TODO: Why does the contaner name start with a slash?

for filename in ${test_sequence[*]}; do
  subheading_spacer=''
  num_tests_subtotal=0
  passed_tests_subtotal=0
  rm -rf ${TESTDIR}
  mkdir -p ${TESTDIR}
  cd ${TESTDIR}
  heading "Running ${filename%.sh} tests ... "
  source "${BASEDIR}/tests/definitions/${filename}"
  echo "   Completed: ${passed_tests_subtotal} / ${num_tests_subtotal} test(s) passed"
  ((num_tests_total=num_tests_total+num_tests_subtotal))
  ((passed_tests_total=passed_tests_total+passed_tests_subtotal))
done
echo ""
echo "Testing completed - ${passed_tests_total} / ${num_tests_total} test(s) passed"
if [ ${passed_tests_total} -eq ${num_tests_total} ] ; then
  exit 0
else
  exit 1
fi
