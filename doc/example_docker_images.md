# Example Docker Images

:exclamation: Only download images from trusted sources.

Reviewing a Dockerfile and building your own image reduces the risk of running
malicious code.

The MicroK8s install process can be executed by a Docker container run from an
image with Ansible installed.

Post-install operations can be executed in a container run from an image with
kubectl and Helm installed (this could be the same container that has Ansible
installed).

The following example images have the above software installed and are
provided for reference:

Docker Image | Description | Build Hierachy
--- | --- | ---
[6871/ansible-k8s](https://hub.docker.com/r/6871/ansible-k8s) | Ubuntu image with Ansible, kubectl and Helm installed | [python](https://github.com/6871/docker/tree/master/images/python) > [ansible](https://github.com/6871/docker/tree/master/images/ansible) > [helm](https://github.com/6871/docker/tree/master/images/helm) > [kubectl](https://github.com/6871/docker/tree/master/images/kubectl)
[6871/ansible](https://hub.docker.com/r/6871/ansible) | Ubuntu image with Ansible installed | [python](https://github.com/6871/docker/tree/master/images/python) > [ansible](https://github.com/6871/docker/tree/master/images/ansible)
[6871/k8s](https://hub.docker.com/r/6871/k8s) | Ubuntu image with kubetl and Helm installed | [kubectl](https://github.com/6871/docker/tree/master/images/kubectl) > [helm](https://github.com/6871/docker/tree/master/images/helm)

Clone [https://github.com/6871/docker.git](https://github.com/6871/docker.git)
to review and build the above image files locally.
