#!/bin/bash

for i in {1..3}
do
    # Generate unique names for the pod and PVC using the counter variable
    pod_name="pod-$i"
    pvc_name="pvc-$i"

    echo "${pvc_name}"
    echo "${pod_name}"

    # Your command to create a pod and PVC with unique names
    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: $pod_name
spec:
  containers:
  - name: my-container
    image: nginx
    volumeMounts:
    - mountPath: /var/myVolume
      name: my-volume
  volumes:
  - name: my-volume
    persistentVolumeClaim:
      claimName: $pvc_name
EOF

    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
 name: $pvc_name
spec:
 storageClassName: rook-cephfs
 accessModes:
    - ReadWriteOnce
 resources:
    requests:
      storage: 1Gi
EOF

done
