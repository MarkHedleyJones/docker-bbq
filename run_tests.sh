#!/usr/bin/env bash

path_base="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" &>/dev/null && pwd -P)"
path_test="${path_base}/tests"

create_repo() {
  # Use the default template as the test container
  cd "${path_test}" || exit 1
  "${path_base}"/bin/create_docker_repo "$1" > /dev/null
  cd "$1" || exit 1
  # Copy in the 'run' script and a success target
  cat << EOF > workspace/target.sh
#!/usr/bin/env sh

echo "SUCCESS"
EOF
  chmod +x workspace/target.sh
}

create_repo "test_repo_lite"
make > /dev/null

create_repo "test_repo_production"
make production > /dev/null

"${path_test}"/tests.sh "${path_test}" "test_repo_lite" "test_repo_production"

# Clean-up tests
docker image rm "test_repo_lite" > /dev/null
docker image rm "test_repo_production" > /dev/null
rm -rf "${path_test}/test_repo_lite" "${path_test}/test_repo_production" "${path_test}/log.txt"
