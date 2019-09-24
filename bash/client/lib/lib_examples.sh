#!/usr/bin/env bash
# Documentation related functions to print usage examples.

##############################################################################
# Print common part of "docker run" command in working usage examples.
function print_docker_run_base() {
  # shellcheck disable=SC2016
  # shellcheck disable=SC1003
  printf '%s\n%s\n' 'docker run --rm --interactive --tty \' \
    '  --name "microk8s-install-example_$(date +%s)" \'
}

##############################################################################
# Print a working "docker run" command example from the passed arguments.
#
# Arguments:
#   1+ : command elemecnts, printed one per line
function print_docker_run_example() {
  print_docker_run_base

  # printf repeats for each array item
  printf '  %s\n' "$@"
}

##############################################################################
# Print microk8s specific docker run examples.
#
# Arguments:
#   1 : container image
#   2 : kubeconfig mount argument string
function print_microk8s_docker_run_examples() {
  local image="$1"
  local mount_kc="$2"

  printf '\n### DOCKER RUN EXAMPLES ####################################\n'
  tput setaf 4 # blue foreground
  printf 'To run kubectl and helm interactively from a bash shell:\n'
  tput setaf 2 # green foreground
  print_docker_run_example "--mount ${mount_kc} \\" "${image} \\" 'bash'
  tput setaf 4 # blue foreground
  printf 'To run kubectl get all --all-namespaces:\n'
  tput setaf 2 # green foreground
  print_docker_run_example "--mount ${mount_kc} \\" "${image} \\" \
    'kubectl get all --all-namespaces'
  # shellcheck disable=SC1003
  tput setaf 4 # blue foreground
  printf 'To run kubectl proxy:\n'
  tput setaf 2 # green foreground
  # shellcheck disable=SC1003
  print_docker_run_example "--mount ${mount_kc} \\" '--publish 8001:8001 \' \
    "${image} \\" 'kubectl proxy --address 0.0.0.0'
  tput setaf 4 # blue foreground
  printf 'To run helm list:\n'
  tput setaf 2 # green foreground
  print_docker_run_example "--mount ${mount_kc} \\" "${image} \\" 'helm list'
  tput sgr 0 # clear formatting
  printf '############################################################\n'
}
