#! /bin/bash

export TARGET_NAMESPACE=rp-sender
export QM_KEY=$(cat ../createcerts/server.key | base64 | tr -d '\n')
export QM_CERT=$(cat ../createcerts/server.crt | base64 | tr -d '\n')
export APP_CERT=$(cat ../createcerts/application.crt | base64 | tr -d '\n')

( echo "cat <<EOF" ; cat customwebconfig.yaml_template ; echo EOF ) | sh > customwebconfig.yaml

oc apply -f customwebconfig.yaml
