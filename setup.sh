#!/usr/bin/env bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

paths_to_try=(
  /home/${USER}/.local/bin
  /home/${USER}/bin
)

for path in ${paths_to_try[@]}; do
  echo "Checking for local binary path at ${path} ... "
  if [[ -d ${path} ]]; then
    if [[ -f ${path}/run ]]; then
      echo "The 'run' script is already exists at this location"
    else
      ln -s ${script_dir}/bin/run ${path}/run
      echo "Created link to 'run'"
    fi
    test=$(export | grep $PATH | grep ${path} > /dev/null)
    if [[ ${test} -ne 0 ]]; then
      echo "The installed path (${path}) does not appear in you \$PATH environment variable"
      echo "Please include the followng line in your shell's startup script (e.g. .bashrc, .zshrc)"
      echo "export PATH=\"\${PATH}:${path}\""
    fi
    echo ""
    echo "The helper script can be uninstalled by running:"
    echo "rm ${path}/run"
    echo ""
    echo "The helper script is automatically updated along with this repository."
    echo "Update using: git pull"
    exit 0
  fi
done
