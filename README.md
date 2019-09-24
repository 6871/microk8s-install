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

## Installing

- [Prerequisites](doc/prerequisites.md)
- [Container-based install and access steps](doc/container_based_install.md)

<br>

---
<sup>1</sup> Example container images:
[example_docker_images.md](doc/example_docker_images.md)

<sup>2</sup> The Ansible scripts can also be run locally without a container.

<sup>3</sup> Size is image dependent, some Ubuntu based examples are: 
[160 MB](https://hub.docker.com/r/6871/k8s),
[312 MB](https://hub.docker.com/r/6871/ansible),
[403 MB](https://hub.docker.com/r/6871/ansible-k8s)
