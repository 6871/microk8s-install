# Installing with [```install_microk8s.sh```](../install_microk8s.sh)

Use script [```install_microk8s.sh```](../install_microk8s.sh) to run a
container based Ansible install of MicroK8s on a target host; it performs the
following actions:

1. Runs [```ansible/microk8s/install.yml```](../ansible/microk8s/install.yml)
   in a container
2. Persists configuration files to the local [```generated```](../generated)
   directory
3. Prints configuration and usage information to the console 

## Running [```install_microk8s.sh```](../install_microk8s.sh)

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
9. Run [```./install_microk8s.sh```](../install_microk8s.sh) with the
   following environment specific variables set:

```
image=""            # Name of Docker image with Ansible installed
target_host=""      # Target host's IP address or name
ssh_key=""          # Path of private key to SSH to host
ssh_user=""         # Username to use to SSH to host 
ask_password=       # Optional sudo password prompt: yes|no

./install_microk8s.sh \
  "${image}" "${target_host}" "${ssh_key}" "${ssh_user}" ${ask_password}
```

:exclamation: If the SSH user needs to enter a password for sudo operations, 
set ```ask_password="yes"```. <sup>1</sup>

For example, the following command uses Docker image
[```6871/ansible:1.0.1```](https://hub.docker.com/r/6871/ansible) to run a
container that runs Ansible to install MicroK8s on host ```192.168.0.100```
using private key ```~/.ssh/id_rsa``` to connect as user ```k8s```, asking for
the user's sudo password<sup>1</sup>:

```
./install_microk8s.sh 6871/ansible:1.0.1 192.168.0.100 ~/.ssh/id_rsa k8s yes
```

On completion, [```install_microk8s.sh```](../install_microk8s.sh) prints the
following information about the created environment to the console:

- kubeconfig file
- dashboard login token
- local dashboard [URL](http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login)<sup>2 3</sup>
- usage examples <sup>4 5</sup>

The kubeconfig file can be used to access the MicroK8s environment from any
machine or container with kubectl or Helm installed.

<br>

---

<sup>1</sup> To suppress sudo password requests for a user (not
recommended):
```sudo echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo -n EDITOR='tee -a' visudo```

<sup>2</sup> The Kubernetes dashboard can only be accessed via kubectl proxy;
see the [Running kubectl proxy](access_microk8s.md#running-kubectl-proxy)
example (or refer to the examples in the install console output).

<sup>3</sup> Use the Token authentication option to log in to the dashboard
(not the kubeconfig option); the token value is printed to the install console
output (and to file).

<sup>4</sup> The image used to run the example containers must have kubectl
and helm installed; some image examples are described here:
[example_docker_images.md](example_docker_images.md).

<sup>5</sup> The usage examples mount the new MicroK8s environment's
kubeconfig file into the container at the following default location
```/root/.kube/config```.

## Accessing MicroK8s

See: [access_microk8s.md](access_microk8s.md)