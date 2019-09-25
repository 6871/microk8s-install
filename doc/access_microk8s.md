# Accessing MicroK8s via containers

The following examples show how to use the kubeconfig file generated by an
install to access the MicroK8s environment through a Docker container.

:exclamation: Use your own Docker images in the following examples;
see [example_docker_images.md](example_docker_images.md).

## Running kubectl
The following example mounts the latest generated kubeconfig file in a
container (using image 
[```6871/k8s:1.0.1```](https://hub.docker.com/r/6871/k8s)) and runs
```kubectl get all --all-namespaces```:

```
# Run this in project's root directory (so "generated" directory can be found)
if [[ -d generated ]]; then
  kc_file="$PWD/$(find generated -type f -name config|sort|tail -1)"

  if [[ -f $kc_file ]]; then
    docker run --rm --interactive --tty \
      --name "microk8s-install-example_$(date +%s)" \
      --mount "type=bind,source=$kc_file,target=/root/.kube/config,readonly" \
      6871/k8s:1.0.1 \
      kubectl get all --all-namespaces
  else
    printf 'Failed to find a kubeconfig file\n'
  fi
else
  printf 'Directory "generated" not found\n'
fi
```

## Running kubectl proxy
The following example mounts the latest generated kubeconfig file in a
container (using image
[```6871/k8s:1.0.1```](https://hub.docker.com/r/6871/k8s)) and runs
```kubectl proxy --address 0.0.0.0``` (terminate with ```CTRL-C```):

```
# Run this in project's root directory (so "generated" directory can be found)
if [[ -d generated ]]; then
  kc_file="$PWD/$(find generated -type f -name config|sort|tail -1)"

  if [[ -f $kc_file ]]; then
    docker run --rm --interactive --tty \
      --name "microk8s-install-example_$(date +%s)" \
      --mount "type=bind,source=$kc_file,target=/root/.kube/config,readonly" \
      --publish 8001:8001 \
      6871/k8s:1.0.1 \
      kubectl proxy --address 0.0.0.0
  else
    printf 'Failed to find a kubeconfig file\n'
  fi
else
  printf 'Directory "generated" not found\n'
fi
```

```--address 0.0.0.0``` binds kubectl proxy to the container's external
addresses (instead of the default non-routable address ```127.0.0.1``` that is
only accessible from within the container). 

```--publish 8001:8001``` makes the remote Kubernetes dashboard 
[URL](http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login)
available from the client machine; it maps port ```8001``` on the local
machine to port ```8001``` inside the container (the default port opened by
the ```kubectl proxy``` command).