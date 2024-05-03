#!/bin/bash

for i in {1..3}
do
    pod_name="pod-$i"
    pvc_name="pvc-$i"

    kubectl delete pod $pod_name
    kubectl delete pvc $pvc_name

done