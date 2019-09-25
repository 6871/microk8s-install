# Installing with ```ansible-playbook```

1. Review the [prerequisites](prerequisites.md)
2. Identify your install target machine
3. Identify and verify your SSH user and keys
4. Open a terminal
5. Navigate to a working directory
6. Clone the microk8s-install repository:
   ```git clone https://github.com/6871/microk8s-install.git```
7. Navigate to the project's root directory: ```cd microk8s-install```
8. Execute the following with values for your environment:

```shell script
# Set these variables for your environment
target_host=                            # Target host IP or name
ssh_user=                               # SSH user Ansible will use
ssh_key=                                # Private key for SSH connection

# Optional variable settings
dir_code="${PWD}/ansible"               # The code to run in the container
dir_out="${PWD}/generated/$(date +%s)"  # Directory for generated files
#ansible_optional='--ask-become-pass'   # Uncomment to request sudo password
ANSIBLE_HOST_KEY_CHECKING=False

# Only run if output directory created OK
if mkdir "${dir_out}"; then
  ansible-playbook \
    "--inventory=${target_host}," \
    "--user=${ssh_user}" \
    ${ansible_optional} \
    ansible/microk8s/install.yml \
    --extra-vars "kubeconfig_local_path=${dir_out}/kubeconfig" \
    --extra-vars "dashboard_token_local_path=${dir_out}/dashboard_token"
fi
```
