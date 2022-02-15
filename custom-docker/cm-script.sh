#!/bin/bash


oc login --token=<token> --server=https://c100-e.us-south.containers.cloud.ibm.com:32033
unset KUBECONFIG
oc whoami
oc project rp-sender
oc exec -it mq-nativeha-tls-persistent-ibm-mq-0 dmpmqcfg > test-output.txt
cat test-output.txt
# export BASEFILE=$(cat test-output.txt | base64)
export BASEFILE=$(base64 test-output.txt | tr -d \\n)
echo $BASEFILE
curl -X PUT -H "Authorization: token <token>" https://api.github.com/repos/ritu-patel/test/contents/test-rp.txt -d "{\"message\":\"your commit message\",\"content\":\"$BASEFILE\"}"
