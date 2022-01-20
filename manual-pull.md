# Steps for manually pulling the IBM Operator Catalog sources

## Overview
- Manually docker pull the `ibm-operator-catalog` catalog sources into the local machine (or proxied into Nexus)
- Manually push from local machine into the Openshift Internal Registry, change CatalogSource yaml image URL, apply.
- Wait for Operator catalogs and then proceed as normal by installing specific product operators (like IBM MQ) through OperatorHub in the OpenShift Web Console UI.


## Steps
- First step is to manually pull to either to your local machine or if it proxies it to Nexus.
```sh
docker pull icr.io/cpopen/ibm-operator-catalog:latest
```

- Next you will need to tag the image if you pulled it locally and push it into the OpenShift Image Registry. Namespace can be whichever namespace you want the ImageStream to be in or you can put it in `openshift-marketplace` for ease. *Note* - If this is in another/new namespace you will need to make sure that the default ServiceAccount in `openshift-marketplace` will be able to pull from that namespace.
```sh
docker tag icr.io/cpopen/ibm-operator-catalog:latest <external-ocp-registry-route>/<namespace>/ibm-operator-catalog:latest
```

- Again, if this was pulled locally to your machine you will need docker login first and then to push it. *Note* - This is assuming the internal OpenShift Registry is externally accessible. You can also forego logging into the registry and pushing if the image already resides in something like Nexus.
```sh
docker login <external-ocp-registry-route> -u <username> -p <password>
docker push <external-ocp-registry-route>/<namespace>/ibm-operator-catalog:latest
```

- Once that is finished create a new yaml file and copy the following contents. Replace `spec.data.image` with the URL of your internal registry and the namespace if you pushed manually or the URL of the image in Nexus registry.
```yaml
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ibm-operator-catalog
  namespace: openshift-marketplace
spec:
  displayName: IBM Operator Catalog
  image: '<image-registry>/<namespace>/ibm-operator-catalog:latest'
  publisher: IBM
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 45m
```

- Apply the yaml.
```sh
oc apply -f catalogsource.yaml
```

- Wait a little bit and the IBM Cloud Pak Operators among others will appear in Operator Hub inside the OpenShift Web Console.
