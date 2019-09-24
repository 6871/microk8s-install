#!/usr/bin/env bash
# Shared client related functions.

##############################################################################
# Verify the given directory is exists.
#
# Arguments:
#   1 : path to directory
function dir_exists() {
  local directory="$1"

  if [[ ! -d "${directory}" ]]; then
    printf '%sERROR: directory "%s" does not exist%s\n' "$(tput setaf 1)" \
      "${directory}" "$(tput sgr 0)" >&2
    return 1
  fi
}

##############################################################################
# Verify the given directory is empty.
#
# Arguments:
#   1 : path to directory
function dir_empty() {
  local directory="$1"

  if [[ $(find "${directory}" -mindepth 1 | wc -l | xargs) -ne 0 ]]; then
    # setaf 1, red foreground; sgr 0, clear
    printf '%sERROR: directory "%s" is not empty%s\n' "$(tput setaf 1)" \
      "${directory}" "$(tput sgr 0)" >&2
    return 1
  fi
}

##############################################################################
# Print a build stage message.
#
# Arguments:
#   1 : stage name
function print_build_stage_banner() {
  tput setaf 4 # blue foreground
  printf '\n### BUILD STAGE ############################################\n'
  tput setaf 3 # yellow foreground
  printf '%s\n' "$1"
  tput setaf 4 # blue foreground
  printf '############################################################\n'
  tput sgr 0 # clear formatting
}

##############################################################################
# Print this host's share directory and files
#
# Arguments:
#   1 : the share directory
function print_shared_files() {
  local dir_share="$1"
  printf '\n### Generated configuration files ##########################\n'
  tput setaf 2 # green foreground
  find "${dir_share}" -type f
  tput sgr 0 # clear formatting
  printf '############################################################\n'
}

##############################################################################
# Print kubeconfig file to the console.
#
# Arguments:
#   1 : shared directory holding kubeconfig file
function print_kubeconfig() {
  local dir_share="$1"
  printf '\n### KUBECONFIG #############################################\n'
  tput setaf 2 # green foreground
  cat "$(find "${dir_share}/kubeconfig" -name 'config')"
  tput sgr 0 # clear formatting
  printf '\n############################################################\n'
}

##############################################################################
# Print the Kubernetes dashboard login token to the console.
#
# Arguments:
#   1 : shared directory holding kubeconfig file
function print_dashboard_token() {
  local dir_share="$1"
  printf '\n### K8S DASHBOARD LOGIN TOKEN ##############################\n'
  tput setaf 2 # green foreground
  cat "$(find "${dir_share}/dashboard_token" -name 'token')"
  tput sgr 0 # clear formatting
  printf '\n############################################################\n'
}

##############################################################################
# Print Kubernetes Dashboard access URL to the console.
#
# Arguments:
#   None
function print_dashboard_url() {
  printf '\n### K8S DASHBOARD URL : via "kubectl proxy" ################\n'
  tput setaf 3 # yellow foreground
  printf '# To access this URL first run the "kubectl proxy" example\n'
  printf '# above (or equivalent); then load the page, select the\n'
  printf '# "Token" login option and enter the token printed above:\n'
  tput setaf 2 # green foreground
  printf "http://localhost:8001/api/v1/namespaces/kube-system/\
services/https:kubernetes-dashboard:/proxy/#!/login\n"
  tput sgr 0 # clear formatting
  printf '############################################################\n'
}

##############################################################################
# Print install complete message.
#
# Arguments:
#   None
function print_install_complete() {
  local message

  if [[ $# -eq 1 ]]; then
    local start_seconds="$1"
    local duration
    local minutes
    local seconds
    duration=$(( SECONDS - start_seconds ))
    minutes=$(( duration / 60 ))
    seconds=$(( duration % 60 ))
    message="$(printf " in %02s:%02s" "${minutes}" "${seconds}")"
  fi

  # setaf 2, green foreground; sgr 0, clear
  printf '\n%sInstall completed%s%s\n\n' "$(tput setaf 2)" "${message}"\
    "$(tput sgr 0)"
}
