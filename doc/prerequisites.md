# Prerequisites

The following are required to run a container based Ansible install of
MicroK8s:

- A client machine to run the install with the following:
  - Bash shell 
  - Private SSH key to connect to the install target machine
  - Docker client software install
    - Docker image(s) with Ansible, kubectl and Helm installed
      - See: [example_docker_images.md](example_docker_images.md)


- A target machine on which MicroK8s will be installed with the following:
  - Ubuntu operating system (tested with Server 18.04 and 19.04)
  - Access to a user with sudo access
  - Internet access (for snap install)
  - Client's public SSH key in ${HOME}/.ssh/authorized_keys
