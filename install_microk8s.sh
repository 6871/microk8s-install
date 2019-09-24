#!/usr/bin/env bash
#
# Top-level script to deploy MicroK8s on a target Ubuntu host; see main
# function for arguments.
#
# Requires Docker client and private key to connect to remote host.
#
# Instructions at: doc/container_based_install.md

# source required functions
. bash/client/lib/lib_client.sh
. bash/client/lib/lib_docker_run.sh
. bash/client/lib/lib_examples.sh

##############################################################################
# Verify arguments.
#
# Returns:
#   0 on success, 1 on failure
function install_valid_arguments() {
  if [[ $# -lt 4 || $# -gt 5 ]]; then
    # setaf 1, red foreground; sgr 0, clear
    printf '%sERROR: invalid arguments for "%s"%s\nUsage: %s %s\n' \
      "$(tput setaf 1)" 'install_microk8s.sh' "$(tput sgr 0)" \
      'docker_image target_host ssh_key ssh_user' \
      '[ansible_ask_for_sudo_password]' >&2
    return 1
  fi
}

##############################################################################
# Main entrypoint.
#
# Arguments:
#   1 : the docker image to run the install
#   2 : target host IP address or name
#   3 : path of private key to SSH to host
#   4 : username to use to SSH to host
#   5 : optional; yes to make Ansible ask for sudo password, defaults to no
# Returns:
#   0 on success, >0 on failure
function main() {
  # Confirm called with required arguments
  if ! install_valid_arguments "$@"; then
    return 65
  fi

  local start_seconds=$SECONDS
  local image="$1"
  local dir_share
  local target_host="$2"
  local ssh_key="$3"
  local ssh_user="$4"
  local ansible_ask_become="${5:-no}"
  local mount_ssh
  local mount_ansible
  local mount_share
  local mount_kubeconfig
  local mount_status
  local ansible_optional

  # Should caller prefer manual remote sudo password authentication...
  if [[ "${ansible_ask_become}" =~ ^[Yy][Ee][Ss]$ ]]; then
    ansible_optional='--ask-become-pass'
  fi

  print_build_stage_banner 'Create host share directory'
  dir_share="${PWD}/generated/$(date +%s)"
  if ! mkdir "${dir_share}"; then
    return 66
  fi

  print_build_stage_banner 'Verify host share directory'
  if ! dir_exists "${dir_share}" || ! dir_empty "${dir_share}"; then
    return 67
  fi

  print_build_stage_banner 'Run container to execute ansible-playbook'

  mount_ssh="$(docker_run_ssh_mount "${ssh_key}")"
  mount_ansible="$(docker_run_ansible_mount "${PWD}/ansible")"
  mount_share="$(docker_run_dir_share_mount "${dir_share}")"

  if ! docker_run \
    --mount "${mount_ssh}" \
    --mount "${mount_ansible}" \
    --mount "${mount_share}" \
    --env DIR_HOST_SHARE="/host/share" \
    --env ANSIBLE_HOST_KEY_CHECKING="False" \
    "${image}" \
    ansible-playbook \
    "--inventory=${target_host}," \
    "--user=${ssh_user}" \
    ${ansible_optional} \
    /microk8s-install/ansible/microk8s/install.yml
  then
    return 68
  fi

  print_build_stage_banner 'Locate MicroK8s kubeconfig file'
  mount_kubeconfig="$(docker_run_kubeconfig_mount "${dir_share}")"
  mount_status=$?
  if [[ ! ${mount_status} -eq 0 ]]; then
    return 69
  fi

  # Re-print key install information and some usage examples
  print_build_stage_banner 'Install summary'
  print_kubeconfig "${dir_share}"
  print_dashboard_token "${dir_share}"
  print_microk8s_docker_run_examples "6871/k8s:1.0.1" "${mount_kubeconfig}"
  print_shared_files "${dir_share}"
  print_dashboard_url
  print_install_complete $start_seconds
}

# Call main function with script's arguments
main "$@"
