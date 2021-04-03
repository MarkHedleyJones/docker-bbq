#!/usr/bin/env bash

path_base="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" &>/dev/null && pwd -P)"
path_test="${path_base}/tests"
dirname_workspace="workspace"

# Outer repo containes the image that executes the tests
dirname_test_repo="test_repo"
path_test_repo="${path_test}/${dirname_test_repo}"
path_test_repo_workspace="${path_test_repo}/${dirname_workspace}"


# Use the default template as the test container
cd "${path_test}" || exit 1
"${path_base}"/bin/create_docker_repo "${dirname_test_repo}" > /dev/null

# Setup and build the outer test repository
cd "${path_test_repo}" || exit 1
make > /dev/null

# Copy in the 'run' script and a success target
cat << EOF > "${path_test_repo_workspace}"/target.sh
#!/usr/bin/env sh

echo "SUCCESS"
EOF
chmod +x "${path_test_repo_workspace}"/target.sh

"${path_test}"/tests.sh "${path_test}" "${dirname_test_repo}"

# Clean-up tests
docker image rm "${dirname_test_repo}" > /dev/null
rm -rf "${path_test_repo}"
