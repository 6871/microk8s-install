# Automated MicroK8s Install

Installs MicroK8s on a target Ubuntu host by running Ansible scripts in a Docker
container. <sup>1 2</sup>

The container-based approach requires a large Docker image<sup> 3</sup> but
has the following benefits:

- Any Docker enabled machine can run the install
- No dependency conflicts are introduced on the install machine
- Multiple environments can be supported concurrently

## Caveats

- The primary goal is fast deployment (not security, resilience or scalability)
- MicroK8s is intended for private non-production environments

## Install Steps

- Review the [prerequisites](doc/prerequisites.md)
- Choose one of the following install methods:
  - [Run the ```install_microk8s.sh``` helper script](doc/install_microk8s.md)
  - [Run ```docker run``` directly](doc/docker_run_install.md)
  - [Run ```ansible-playbook``` directly](doc/ansible_playbook_install.md)
- Post-install:
  - [Access MicroK8s via a container](doc/access_microk8s.md)

## Releases

Version | Installs MicroK8s | Description | Date
--- | --- | --- | ---
[```1.1.0```](https://github.com/6871/microk8s-install/tree/1.0.0) | ```1.16/stable``` | Applies Tiller deployment workaround<br>https://github.com/helm/helm/issues/6374 | 2019.09.29
[```1.0.0```](https://github.com/6871/microk8s-install/tree/1.0.0) | ```1.15/stable``` | Breaking change in ```1.16/stable``` | 2019.09.26

<br>

---
<sup>1</sup> Example container images:
[example_docker_images.md](doc/example_docker_images.md)

<sup>2</sup> The Ansible scripts can also be run locally without a container.

<sup>3</sup> Size is image dependent, some Ubuntu based examples are: 
[160 MB](https://hub.docker.com/r/6871/k8s),
[312 MB](https://hub.docker.com/r/6871/ansible),
[403 MB](https://hub.docker.com/r/6871/ansible-k8s)
