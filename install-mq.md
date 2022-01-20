# Steps for installing IBM MQ Operator

## Overview 
- This assumes you have installed all the IBM Operator CatalogSources whether manually or airgapped in some fashion.
- Install the operator via OperatorHub.
- We will need to create an Openshift secret to house the entitlement key in a namespace that you choose to deploy the product into.


## Steps
- Assuming you have all the catalog sources installed you should be able to see the Cloud Pak operators inside OperatorHub.
- Traverse to the `Operator Hub` in the Openshift Web Console UI.
- Filter/search for `IBM MQ`. Click it and select `Install`. The channel should ideally be `1.7.0` as that's the newest version. You can customize it so that the operator watches a single namespace or all.
- Wait for it to install, this will pull in other necessary dependences like IBM Foundational services, ODLM, etc. 
- Once this is successful we now need to create an Openshift secret for the IBM Entitlement key. 
- Be logged into the OCP cluster via the cli and for purposes of demonstration we'll use `mq` as a namespace.
```
oc new-project mq
oc project mq
```

- Create the secret and replace with your Entitlement Key.
```sh
oc create secret docker-registry ibm-entitlement-key \
    --docker-username=cp \
    --docker-password=<entitlement_key> \
    --docker-server=cp.icr.io \
    --namespace=<mq>
```

- With that secret we can either create an IBM MQ QueueManager via the Web console or providing a yaml and applying that through the CLI. 
