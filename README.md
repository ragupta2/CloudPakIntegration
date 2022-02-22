# Bastion Install of CloudPak for Integration #

This is a simple solution for having a bastion installation of IBM's Cloud Pak for Integration by using a Docker container with all the necessary tools and a script to make it a very simple process.  Naturally, the simple that is going to run this must have Docker installed to build and run.

- The Dockerfile needs to have the location of the `oc` tool to be downloaded.  This location can be located by going to the OpenShift Container Platform console and clicking on the question mark (?) in the upper right and then selecting the `Command line tools`. 
- Copy the hostname and port and update the Dockerfile's `OC_LOCATION` with that information. For `OC_LOCATION` you should click the appropriate download link. For example for Linux x86_64 you would get the link from `Download oc for Linux for x86_64`. An example URL looks like `https://downloads-openshift-console.example.com/amd64/linux/oc.tar`. You do not need `https` or the trailing `/amd64/linux/oc.tar/` and you will only need `downloads-openshift-console.example.com` for the `OC_LOCATION` environment variable. 

- Next, update the `installcp4i.sh` file.  There are several fields at the top of the file that need information.  Also, the project/namespace that is to be used can be changed along with the version of CP4I that will be used.  Those fields are `ENTTITLEMENT_KEY`, `LOCAL_DOCKER_REGISTRY_HOST`, `LOCAL_DOCKER_USER`, and `LOCAL_DOCKER_PASSWORD`.  

- To build the Docker image use this command: `docker build -t cp4i:latest -f Dockerfile .`

- Now you will need to run the container, to run it use `docker run -i -t cp4i bash`.  This will bring the user into the bash command prompt of the container.  
- Signon to the target OCP environment using the `oc login` command, and then run the install script `/root/installcp4i.sh`.

If all goes well, then the local registry will be populated with the CP4I images and the CatalogSources will be added pointing to those repositories.  


```
curl -i -k https://custom-web-console-route-rp-sender./ibmmq/rest/v1/messaging/qmgr/QUICKSTART/queue/APPQ/message -X POST -u <user>:<pass> -H "ibm-mq-rest-csrf-token: value" -H "Content-Type: application/json" --data "{\"msg\":\"hellowrold\"}"
```
```
curl -i -k https://custom-web-console-route-rp-sender./ibmmq/rest/v1/messaging/qmgr/QUICKSTART/queue/APPQ/message -X DELETE -u <user>:<pass> -H "ibm-mq-rest-csrf-token: blank"

```
