#!/bin/bash

export QM_YAML_NAME=nativeha-sender-qm-ibm
export NAMESPACE=rp-sender
export CHANNEL_NAME=TO.QM22
# echo "Printing envs read from secret...."
# echo $OCP_USER
# echo $OCP_PASS

oc login --token=<token> --server=https://c100-e.us-south.containers.cloud.ibm.com:32033
# oc login --username=user --password=token --server=https://c100-e.us-south.containers.cloud.ibm.com:32033
unset KUBECONFIG
oc project $NAMESPACE
export PODNAME=`oc get pods | gawk 'match($2, /([0-9])+\/([0-9])+/, a) {if (a[1] == a[2] && $3 != "Completed") print $0}' | grep $QM_YAML_NAME | awk '{print $1}'`
echo $PODNAME 
echo "Stopping channel ....."
echo "STOP CHANNEL($CHANNEL_NAME)" > stop-chl.mqsc
oc exec -it $PODNAME  -- /bin/bash -c runmqsc < stop-chl.mqsc

# oc create configmap stop-chl --from-file=stop-chl.sh=./stop-chl.sh
