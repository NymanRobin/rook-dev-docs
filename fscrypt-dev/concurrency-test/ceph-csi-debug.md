# Run custom ceph-csi image

To run custom ceph-csi image with rook test cluster you can follow the steps below:
In the rook repository under `deploy/examples/operator.yaml` you need to change the ceph-csi settings

The following parameters are at least of interest for us:

ROOK_CSI_CEPH_IMAGE: "rook/cephcsi:master"
ROOK_CSI_ALLOW_UNSUPPORTED_VERSION: "true"

The image name set in the ROOK_CSI_CEPH_IMAGE determines what you want to set in the ceph-csi repo
To get the correct image here you should set the same image name/tag in ceph-csi repository.
The name should be set in the following variable $(CSI_IMAGE) after that you can run

```console
eval $(minikube --profile rook docker-env)
make image-cephcsi
```

## Concurrency issue in fscrypt implementation in ceph-csi debug doc

Currently a concrrency issue can be observed by using the scripts in this repository.
First step is to setup the storage class and encryption secrets from `storage-class-create`

```console
kubectl create -f storage-class-create
```

After that the error can be observed with the script `kube-deploy.sh`

```console
./kube-deploy.sh
```

The teardown of the test-case can be done with the following step

```console
./kube-delete.sh
kubectl delete -f storage-class-create
```

### Resolution

This bug was in the fscrypt implementation and was resolved in this PR!
https://github.com/google/fscrypt/pull/413
