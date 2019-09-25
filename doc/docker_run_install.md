# Installing with ```docker run```

1. Review the [prerequisites](prerequisites.md)
2. Review [example_docker_images.md](example_docker_images.md) and identify
   the Docker image you will execute
3. Identify your install target machine
4. Identify and verify your SSH user and keys
5. Open a terminal
6. Navigate to a working directory
7. Clone the microk8s-install repository:
   ```git clone https://github.com/6871/microk8s-install.git```
8. Navigate to the project's root directory: ```cd microk8s-install```
9. Execute the following with values for your environment:

```shell script
# Set these variables for your environment
docker_image=                           # Docker image to run
target_host=                            # Target host IP or name
ssh_user=                               # SSH user Ansible will use
ssh_key=                                # Private key for SSH connection

# Optional variable settings
dir_code="${PWD}/ansible"               # The code to run in the container
dir_out="${PWD}/generated/$(date +%s)"  # Directory for generated files
#ansible_optional='--ask-become-pass'   # Uncomment to request sudo password

# Only run if output directory created OK
if mkdir "${dir_out}"; then
  # Mount SSH key, code and generated folder in container and run install
  ssh_target_key="/root/.ssh/$(basename "${ssh_key}")"
  mount_ssh="type=bind,source=${ssh_key},target=${ssh_target_key},readonly"
  mount_code="type=bind,source=${dir_code},target=/code,readonly"
  mount_out="type=bind,source=${dir_out},target=/host/share"
  
  docker run \
    --rm --interactive --tty \
    --name "microk8s-install-example_$(date +%s)" \
    --mount "${mount_ssh}" \
    --mount "${mount_code}" \
    --mount "${mount_out}" \
    --env DIR_HOST_SHARE="/host/share" \
    --env ANSIBLE_HOST_KEY_CHECKING="False" \
    "${docker_image}" \
    ansible-playbook \
    "--inventory=${target_host}," \
    "--user=${ssh_user}" \
    ${ansible_optional} \
    /code/microk8s/install.yml
fi
```
