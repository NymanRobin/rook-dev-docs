---
title: Cephfs + fscrypt
---

cephfs + fscrypt allows encryption on filesystem level instead of needing to encrypt on
storage level.

## Developement

To deploy this you will need start the rook dev cluster see insturctions in
[dev-guide](../rook-developement.md)

After the cluster is running you can create the test_deployment located in this
directory. It comes with minimal working example of filesystem, configmap, secret,
deployment and storage class.

1) Create nginx with encrypted filesystem

```console
kubectl create -f test_deployment
```

2) Patch the clusterroles to allow for reading secrets / config maps

```console
kubectl edit clusterrole cephfs-external-provisioner-runner
kubectl edit clusterrole cephfs-csi-nodeplugin 
```

Hopefully this will be made redundant when this issue is solved
[#14035]([fscrypt-dev/developement.md](https://github.com/rook/rook/issues/14035))
This is a bit problematic since the common.yaml is separated from the upstream
projects that this is based on.

## Kernel is not supported error

After this changes are done is likely to get error that kernel version is not supported.
This is since ther cephfs + encryption support is added in kernel version 6.6.
At the time of writing this kernel is not supported by any major LTS Releases and
Minikube often updates their ISO image retroactivley so will most likely be a while
before this gets offical support. However due to work done by other we can at the moment
utalise the following setup. Warning this is no offical documentation use with own
consideration

Start by cloning this fork of minikube:

```console
git clone git@github.com:irq0/minikube.git
```

You can build this version by running make
```console
make
```

Then use the binary directly when running cluster setup with the following ISO image:

```console
export MINIKUBE_ISO_URL="https://github.com/irq0/minikube/releases/download/2022-11-08-master%2Bfscrypt-kernel/minikube-amd64.iso"
```

```console
./minikube --iso_url="${MINIKUBE_ISO_URL}"
```

## NOTE

Should try to build a proper custom ISO-image with kernel 6.6 to get away from steps above
