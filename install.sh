#!/usr/bin/env bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

scripts=("$(ls -1A "bin")")

paths_to_try=(
  "/home/${USER}/.local/bin"
  "/home/${USER}/bin"
)

install_path=NULL
for path in ${paths_to_try[*]}; do
  if [[ ${install_path} == NULL ]] && [[ -d ${path} ]]; then
    echo "Detected installation path at: ${path}"
    install_path="${path}"
  fi
done

if [[ ${install_path} == NULL ]]; then
  echo "No pre-existing intallation path found, installing to ${paths_to_try[0]}"
  install_path="${paths_to_try[0]}"
  mkdir -p ${install_path}
fi

echo

for script in ${scripts[*]}; do
  if [[ -f ${install_path}/${script} ]]; then
    echo "'${script}' is already linked to the installation path"
  else
    ln -sf "${script_dir}/bin/${script}" "${install_path}/${script}"
    echo "Created link to '${script}'"
  fi
done

echo 
echo "Deleting or moving this repository will break docker-bbq"
echo
echo "NOTE: The helper scripts can be uninstalled by running:"
for script in ${scripts[*]}; do
  echo "      rm ${install_path}/${script}"
done

test=$(export | grep PATH= | grep "${install_path}")
if [[ "${test}" == "" ]]; then
  path_update="export PATH=\"\${PATH}:${install_path}\""
  if [[ -f /home/$USER/.bashrc ]]; then
    echo "${path_update}" >> /home/$USER/.bashrc
  fi
  if [[ -f /home/$USER/.zshrc ]]; then
    echo "${path_update}" >> /home/$USER/.zshrc
  fi
  echo
  echo "NOTE: Installation path has been added to your system's \$PATH vairable"
  echo "      Start a new terminal or reload your environment variables:"
  echo "      source ~/.$(basename ${SHELL})rc"
fi
