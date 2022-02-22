#! /bin/bash

export TARGET_NAMESPACE=rp-sender

oc delete queuemanager custom-web-console-cp4i -n $TARGET_NAMESPACE
oc delete secret customwebcert -n $TARGET_NAMESPACE
oc delete configmap customwebmqsc -n $TARGET_NAMESPACE
oc delete service custom-web-console-service-cp4i-ibm-mq -n $TARGET_NAMESPACE
oc delete route custom-web-console-route -n $TARGET_NAMESPACE
oc delete configmap customwebconfig -n $TARGET_NAMESPACE
