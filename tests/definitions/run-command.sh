#!/usr/bin/env bash

create-repo debian test > /dev/null 2>&1
cd test
repo_path=$(pwd)

test_sequence() {
  name="Run command in container"
  pass 'run rm --help | grep "Remove (unlink) the FILE(s)."'

  name="Run target from outside workspace"
  pass 'run workspace/target.sh | grep boom'

  cd "${repo_path}/workspace"
  name="Run target from inside workspace"
  pass 'run ./target.sh | grep boom'

  cd /tmp
  name="Run target outside repo - single command"
  pass 'run ${repo_path}/workspace/target.sh | grep boom'

  name="Run target outside repo - split command"
  pass 'run ${repo_path} /workspace/target.sh | grep boom'
}

# Standard
make > /dev/null 2>&1
printf "#!/usr/bin/env sh\necho boom\n" > workspace/target.sh
chmod +x workspace/target.sh
subheading "Development builds"
test_sequence


# Build production image with target script
cd ${repo_path}
make production > /dev/null 2>&1
rm workspace/target.sh
subheading "Production builds"
test_sequence
