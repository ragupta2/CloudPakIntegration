#!/bin/bash

# Script based mostly on the docs from https://www.ibm.com/docs/en/cloud-paks/cp-integration/2021.4?topic=environment-installing-in-air-gapped-bastion-host

# Fill in the necessary variables first
NAMESPACE=cp4i
ENTTITLEMENT_KEY=***** #add entitlement key
LOCAL_DOCKER_REGISTRY_HOST=*****  #docker registry URL from nexus
LOCAL_DOCKER_USER=******   #replace with nexus user
LOCAL_DOCKER_PASSWORD=*********** #replace with nexus password
CASE_VERSION=2.5.0 # https://github.com/IBM/cloud-pak/tree/master/repo/case/ibm-cp-integration -> 2.5.0 is CP4I v2021.4.1

# ----------# Environment variables for an offline install
# Combination of Sections 3.4. Step 1. and Section 4 Step 1.
CASE_NAME=ibm-cp-integration
CASE_ARCHIVE=${CASE_NAME}-${CASE_VERSION}.tgz
CASE_INVENTORY_SETUP=operator
OFFLINEDIR=$HOME/offline
CASE_REPO_PATH=https://github.com/IBM/cloud-pak/raw/master/repo/case
CASE_LOCAL_PATH=$OFFLINEDIR/$CASE_ARCHIVE
CASE_INVENTORY_SETUP=operator
OFFLINEDIR_ARCHIVE=offline.tgz
CASE_LOCAL_PATH=$OFFLINEDIR/$CASE_ARCHIVE
LOCAL_DOCKER_REGISTRY_PORT=443
LOCAL_DOCKER_REGISTRY=$LOCAL_DOCKER_REGISTRY_HOST:$LOCAL_DOCKER_REGISTRY_PORT

# Check if the oc login command has been issued
oc status

if [ $? -ne 0 ];
then
   echo "Must login to oc first - exiting"
   exit 1
fi

# Create a new project/namespace (if it doesn't already exist) and switch context over to it
oc new-project $NAMESPACE
oc project $NAMESPACE

# Section 2 - Step 3. This will download the Cloud Pak for Integration installer and image inventory to your host.
cloudctl case save --repo $CASE_REPO_PATH --case $CASE_NAME --version $CASE_VERSION --outputdir $OFFLINEDIR

# Storing credentials
# Section 3.2. - Step 1. This will setup the credentials for your local registry.
cloudctl case launch --case $HOME/offline/$CASE_ARCHIVE --inventory $CASE_INVENTORY_SETUP --action configure-creds-airgap --args "--registry $LOCAL_DOCKER_REGISTRY_HOST --user $LOCAL_DOCKER_USER --pass $LOCAL_DOCKER_PASSWORD"
# Also Section 3.2. - Step 1. This command will setup the credentials to access the IBM Entitled Registry (thus the need of the entitlement key)
cloudctl case launch --case $HOME/offline/$CASE_ARCHIVE --inventory $CASE_INVENTORY_SETUP --action configure-creds-airgap --args "--registry cp.icr.io --user cp --pass $ENTTITLEMENT_KEY"

# Section 3.4. Step 3. This will mirror the images into the local Docker Registry
cloudctl case launch --case $CASE_LOCAL_PATH --inventory $CASE_INVENTORY_SETUP --action mirror-images --args "--registry $LOCAL_DOCKER_REGISTRY --inputDir $OFFLINEDIR"

# Section 3.4. Step 2. This will configure a global image pull secret and ImageContentSourcePolicy CR.
# The ImageContentSourcePolicy allows the OCP cluster the ability to recognize the local Docker registry.
cloudctl case launch --case $HOME/offline/$CASE_ARCHIVE --inventory $CASE_INVENTORY_SETUP --action configure-cluster-airgap --namespace $NAMESPACE --args "--registry $LOCAL_DOCKER_REGISTRY --user $LOCAL_DOCKER_USER --pass $LOCAL_DOCKER_PASSWORD --inputDir $OFFLINEDIR"

# Not a necessary step - just a bit of logging to verify the above step
oc get imageContentSourcePolicy

# Section 4. Step 2. Creating the CatalogSource which is a collection of Operator metadata
cloudctl case launch --case $HOME/offline/${CASE_ARCHIVE} --inventory ${CASE_INVENTORY_SETUP} --action install-catalog --namespace ${NAMESPACE} --args "--registry ${LOCAL_DOCKER_REGISTRY} --inputDir $HOME/offline --recursive"

# Again to verify the CatalogSource as well as the Operator pods
oc get pods -n openshift-marketplace
oc get catalogsource -n openshift-marketplace
