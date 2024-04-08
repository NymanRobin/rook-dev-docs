---
title: Developer Environment
---

Documentation is based on offical documentation from the rook project with some more detail

## Minikube

The developers of Rook are working on Minikube and thus it is the recommended way to quickly get
Rook up and running. Minikube should not be used for production but the Rook authors
consider it great for development. While other tools such as k3d/kind are great, users have faced
issues deploying Rook.

**Always use a virtual machine when testing Rook. Never use your host system where local devices may mistakenly be consumed.**

To install Minikube follow the [official
guide](https://minikube.sigs.k8s.io/docs/start/). It is recommended to use the
kvm2 driver when running on a Linux machine and the hyperkit driver when running on a MacOS. Both
allow to create and attach additional disks to the virtual machine. This is required for the Ceph
OSD to consume one drive.  We don't recommend any other drivers for Rook. You will need a Minikube
version 1.23 or higher.

## Creating a dev cluster

To accelerate the development process, users have the option to employ the script located
at `tests/scripts/create-dev-cluster.sh`. This script is designed to rapidly set
up a new minikube environment, apply the CRDs and the common file, and then utilize the
`cluster-test.yaml` script to create the Rook cluster. Once setup, users can use the different `*-test.yaml`
files from the `deploy/examples/` directory to configure their clusters. This script supports
the possibility of creating multiple rook clusters running on the same machine by using the option
`-p <profile-name>`.


## Updating the Rook Operator in developement

Developers can test quickly their changes by building and using the local Rook image
on their minikube cluster. Notice this process will reset all CRDs (Why this happens
could be investigated)

1) Set the local Docker environment to use minikube:

```console
eval $(minikube docker-env -p rook)
```

2) Build your local Rook image. The following command will generate a Rook image
labeled in the format `local/ceph-<arch>`.

```console
make BUILD_REGISTRY=local
```

3) Tag the generated image as `rook/ceph:master` so operator will pick it.

```console
docker tag "local/ceph-$(go env GOARCH)" 'rook/ceph:master'
```

4) Restart the rook operator

```console
kubectl delete pod -n rook-ceph -l app=rook-ceph-operator
```

## Updating CRDs

Developers can test CRD changes by doing the changes for example in:
`pkg/apis/ceph.rook.io/v1/types.go`

1) Make crds for changes to be generated:

```console
make crds
```

2) Apply changes to the dev cluster:

```console
kubectl apply -f deploy/examples/crds.yaml
```

### Note
If you remake the operator the crd changes might be overwritten

## Specific Feature Developement

### Cephfs + fscrypt

To develop and test cephfs encryption requires custom kernel see
[documentation](fscrypt-dev/developement.md)
