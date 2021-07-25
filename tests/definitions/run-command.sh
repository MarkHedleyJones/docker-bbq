#!/usr/bin/env bash

create-repo debian ${TESTREPO} > /dev/null 2>&1
cd ${TESTREPO}
repo_path=$(pwd)

# Standard
make > /dev/null 2>&1
printf "#!/usr/bin/env sh\necho boom\n" > workspace/target.sh
chmod +x workspace/target.sh
subheading "Development builds"


name="Run command in container"
pass "run rm --help | grep 'Remove (unlink) the FILE(s).'"

name="Run target from repository root"
pass "run workspace/target.sh | grep boom"

cd "${repo_path}/workspace"
name="Run target from inside workspace"
pass "run ./target.sh | grep boom"

cd /tmp
name="Run target outside repository"
pass "run --repo ${repo_path} workspace/target.sh | grep boom"


# Build production image with target script
cd ${repo_path}
make production > /dev/null 2>&1
#rm workspace/target.sh
subheading "Production builds"

name="Run command in container"
pass "run rm --help | grep 'Remove (unlink) the FILE(s).'"

name="Run target from inside repository"
pass "run workspace/target.sh | grep boom"

cd /tmp
name="Run target outside repository"
pass "run --repo ${repo_path} workspace/target.sh | grep boom"
