#!/usr/bin/env bash

set -u

width_of_test_titles=40

test_basedir="/tmp/docker-bbq"

BASEDIR="$( cd "$( dirname "$(dirname "${BASH_SOURCE[0]}")")" >/dev/null 2>&1 && pwd )"
TESTDIR="${test_basedir}/temporary"
TESTREPO="test"

verbosity=0
abort_on_failure=0

rm -rf ${test_basedir}
mkdir -p ${test_basedir}

test_sequence=(
  bbq-create.sh
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
  -t, --templates  Run only the template repository tests
  -d, --debug      Abort on first failure and don't clean-up

  --template <template-name>
                   Run only the tests against the specified template name
EOF
  exit
}

# Used to specify a specific template to test
test_template=NULL

# Parse parameters
while :; do
  case "${1-}" in
  -h | --help) usage ;;
  -v | --verbose) verbosity=1 ;;
  -t | --templates) test_sequence=(templates.sh) ;;
  -t | --template) test_sequence=(templates.sh) && test_template=$2 && shift ;;
  -d | --debug) abort_on_failure=1 ;;
  -a | --all) test_sequence+=(templates.sh) ;;
  -?*) error "Unknown option: $1" ;;
  *) break ;;
  esac
  shift
done


# The following variables are available to testfiles
export TESTDIR
export TESTREPO
export DOCKER_BBQ_NON_INTERACTIVE=1

# Override locations to remove need for installation before test
bbq-create() {
  echo "${BASEDIR}/bin/bbq-create $*"
  "${BASEDIR}/bin/bbq-create" $*
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
  if [ ${success} -eq 0 ] && [ ${verbosity} -eq 1 ]; then
    if [ -s "${TESTDIR}/output" ]; then

      printf "\n######### DEBUG OUTPUT FROM FAILED TEST START #########\n"
      cat "${TESTDIR}/output"
      printf "########## DEBUG OUTPUT FROM FAILED TEST END ##########\n\n"
    else
      echo "   FAILED TEST PRODUCED NO DEBUG OUTPUT"
    fi
    echo "Test command: $*"
  fi
  if [[ ${success} -eq 0 ]] && [[ ${abort_on_failure} -eq 1 ]]; then
    echo "Aborting on failure due to --debug flag"
    echo "State on failure can be found at ${TESTDIR}"
    exit 1
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

clean() {
  # Reset output/formatting variables
  subheading_spacer=''
  num_tests_subtotal=0
  passed_tests_subtotal=0

  # Regenerate clean test directories
  rm -rf ${TESTDIR}
  mkdir -p ${TESTDIR}
  cd ${TESTDIR}

  # Kill any already running containers with the TESTREPO's name
  running="$(docker ps --quiet --filter name="${TESTREPO}")"
  if [ ! -z "${running}" ]; then
    docker kill "${running}"
  fi
}

for filename in ${test_sequence[*]}; do
  clean
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
