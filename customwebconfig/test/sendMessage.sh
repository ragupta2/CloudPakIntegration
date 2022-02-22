#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
export MQCCDTURL="${DIR}/ccdt_generated.json"
export MQSSLKEYR="${DIR}/../createcerts/application"

export ROOTURL="$(oc get IngressController default -n openshift-ingress-operator -o jsonpath='{.status.domain}')"
( echo "cat <<EOF" ; cat ccdt_template.json ; echo EOF ) | sh > ccdt_generated.json

echo "Starting amqsphac" QUICKSTART
/opt/mqm/samp/bin/amqsphac APPQ QUICKSTART


curl -i -k https://custom-web-console-route-rp-sender.itzroks-550004s7y8-eo626g-4b4a324f027aea19c5cbc0c3275c4656-0000.us-south.containers.appdomain.cloud/ibmmq/rest/v1/messaging/qmgr/QUICKSTART/queue/APPQ/message -X POST -u mqadmin:passw0rd -H "ibm-mq-rest-csrf-token: blank" -H "Content-Type: text/plain;charset=utf-8" -d "Hello World!"


curl -i -k https://custom-web-console-route-rp-sender.itzroks-550004s7y8-eo626g-4b4a324f027aea19c5cbc0c3275c4656-0000.us-south.containers.appdomain.cloud/ibmmq/rest/v1/messaging/qmgr/QUICKSTART/queue/APPQ/message -X POST -u mqadmin:passw0rd -H "ibm-mq-rest-csrf-token: value" -H "Content-Type: application/json" --data "{\"msg\":\"1\"}"

curl -i -k https://custom-web-console-route-rp-sender.itzroks-550004s7y8-eo626g-4b4a324f027aea19c5cbc0c3275c4656-0000.us-south.containers.appdomain.cloud/ibmmq/rest/v1/messaging/qmgr/QUICKSTART/queue/APPQ/message -X DELETE -u mqadmin:passw0rd -H "ibm-mq-rest-csrf-token: blank"