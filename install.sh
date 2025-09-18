#!/usr/bin/env bash

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

scripts=("$(ls -1A "${script_dir}/bin")")

paths_to_try=(
	"/home/${USER}/.local/bin"
	"/home/${USER}/bin"
)

find_install_path() {
	install_path=NULL
	for path in ${paths_to_try[*]}; do
		if [[ ${install_path} == NULL ]] && [[ -d ${path} ]]; then
			echo "Detected installation path at: ${path}"
			install_path="${path}"
		fi
	done

	if [[ ${install_path} == NULL ]]; then
		echo "No pre-existing installation path found, will use ${paths_to_try[0]}"
		install_path="${paths_to_try[0]}"
		mkdir -p ${install_path}
	fi
}

do_install() {
	find_install_path
	echo
	echo "Installing docker-bbq (copying files)..."

	for script in ${scripts[*]}; do
		target="${install_path}/${script}"
		source="${script_dir}/bin/${script}"

		rm -f "${target}"
		cp "${source}" "${target}"
		chmod +x "${target}"
		echo "  ✓ ${script}"
	done

	echo
	echo "Installation complete. You can safely delete this repository if desired."
	check_path
}

do_link() {
	find_install_path
	echo
	echo "Installing docker-bbq (symbolic links)..."

	for script in ${scripts[*]}; do
		target="${install_path}/${script}"
		source="${script_dir}/bin/${script}"

		rm -f "${target}"
		ln -sf "${source}" "${target}"
		echo "  ✓ ${script}"
	done

	echo
	echo "Installation complete. WARNING: Moving this repository will break docker-bbq."
	check_path
}

do_uninstall() {
	find_install_path
	echo
	echo "Uninstalling docker-bbq..."

	removed_count=0
	for script in ${scripts[*]}; do
		if [[ -f ${install_path}/${script} ]] || [[ -L ${install_path}/${script} ]]; then
			rm -f "${install_path}/${script}"
			echo "Removed '${script}'"
			((removed_count++))
		fi
	done

	if [[ ${removed_count} -eq 0 ]]; then
		echo "No docker-bbq scripts found to remove"
	else
		echo
		echo "docker-bbq has been uninstalled"
	fi
}

check_path() {
	test=$(export | grep PATH= | grep "${install_path}")
	if [[ "${test}" == "" ]]; then
		path_update="export PATH=\"\${PATH}:${install_path}\""
		if [[ -f /home/$USER/.bashrc ]]; then
			echo "${path_update}" >>/home/$USER/.bashrc
		fi
		if [[ -f /home/$USER/.zshrc ]]; then
			echo "${path_update}" >>/home/$USER/.zshrc
		fi
		echo
		echo "NOTE: Installation path has been added to your system's \$PATH variable"
		echo "      Start a new terminal or reload your environment variables:"
		echo "      source ~/.$(basename ${SHELL})rc"
	fi
}

show_usage() {
	cat <<EOF
Usage: $(basename "$0") [OPTION]

Install docker-bbq commands to your local bin directory.

Options:
  --install    Copy docker-bbq scripts to local bin (default)
  --link       Create symbolic links to docker-bbq scripts
  --uninstall  Remove docker-bbq scripts from local bin
  --help, -h   Show this help message

Examples:
  $(basename "$0")              # Install by copying (default)
  $(basename "$0") --install    # Install by copying
  $(basename "$0") --link       # Install using symbolic links
  $(basename "$0") --uninstall  # Remove docker-bbq

When no option is specified, '--install' is used by default.
EOF
}

command="${1:-install}"

case "${command}" in
install | --install)
	do_install
	;;
link | --link)
	do_link
	;;
uninstall | --uninstall)
	do_uninstall
	;;
help | -h | --help)
	show_usage
	exit 0
	;;
*)
	echo "Unknown command: ${command}"
	echo "Use '$(basename "$0") help' for usage information"
	exit 1
	;;
esac
