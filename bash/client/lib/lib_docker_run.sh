#!/usr/bin/env bash
# Shared docker related functions.

##############################################################################
# Generate and print docker run --mount string for SSH key.
#
# Arguments:
#   1 : path of private SSH key
function docker_run_ssh_mount() {
  local ssh_key="$1"
  local ssh_target_key
  ssh_target_key="/root/.ssh/$(basename "${ssh_key}")"

  mount_ssh="type=bind,source=${ssh_key},target=${ssh_target_key},readonly"
  printf '%s' "${mount_ssh}"
}

##############################################################################
# Generate and print docker run --mount string for share directory.
#
# Arguments:
#   1 : path of share directory
function docker_run_dir_share_mount() {
  printf '%s' "type=bind,source=$1,target=/host/share"
}

##############################################################################
# Generate and print docker run --mount string for ansible directory.
#
# Arguments:
#   1 : path of ansible directory
function docker_run_ansible_mount() {
  printf '%s' "type=bind,source=$1,target=/microk8s-install/ansible,readonly"
}

##############################################################################
# Generate and print docker run --mount string to stdout.
#
# Arguments:
#   1 : path to kubeconfig file, or parent directory of kubeconfig file
#   2 : optional name of kubeconfig file to serach for if parent directory
#       specified; defaults to "config".
# Returns:
#   0 on success, non-zero on failure.
function docker_run_kubeconfig_mount() {
  local path="$1"
  local file="${2:-config}"
  local mount_file
  local find_result

  if [[ $# -lt 1 || $# -gt 2 ]]; then
    printf '%sERROR: invalid arguments: %s%s\n' "$(tput setaf 1)" \
      'usage: config_file_or_dir [config_file_name]' "$(tput sgr 0)" >&2
    return 64
  fi

  if [[ -f "${path}" ]]; then
    mount_file="${path}"
  elif [[ -d ${path} ]]; then
    mount_file="$(find "${path}" -name "${file}")"
    find_result=$?
    if [[ ! ${find_result} ]]; then
      printf '%sERROR: did not find "%s" in "%s" %s\n' "$(tput setaf 1)" \
        "${file}" "${path}" "$(tput sgr 0)" >&2
      return 65
    fi
  else
    printf '%sERROR: "%s" is not a file or directory%s\n' "$(tput setaf 1)" \
      "${path}" "$(tput sgr 0)" >&2
    return 66
  fi

  printf '%s' "type=bind,source=${mount_file},target=/root/.kube/config"
}

##############################################################################
# Execute a base docker run command with supplied arguments.
#
# Arguments:
#   1+: arguments for base docker run command to use
# Returns:
#   0 on success, non-zero on failure.
function docker_run() {
  local cmd
  cmd=(docker run --rm --interactive --tty
    --name "microk8s-install_$(date +%s)" "$@")
  printf 'command: %s\n' "${cmd[*]}" >&2
  "${cmd[@]}"
}
