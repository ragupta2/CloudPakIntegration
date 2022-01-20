FROM fedora:latest

# MUST SET OC HOSTNAME:PORT
# In the OCP console, click on the ? (question mark) and then select "Command line tools". Then click 
# "Download oc for Linux for x86_64" to get the link but only keep the URL prior to "/amd64/linux/oc.tar".
ARG OC_LOCATION=downloads-openshift-console.cp4intpg-wdc04-a5tbti-8946bbc006b7c6eb0829d088919818bb-0000.us-east.containers.appdomain.cloud/

USER root
RUN yum -y update \
    && yum -y install skopeo openssl podman httpd-tools docker gzip tar wget hostname findutils

RUN mkdir $HOME/offline \
    && wget https://$OC_LOCATION/amd64/linux/oc.tar \
    && tar -xvf oc.tar \
    && mv oc /usr/local/bin \
    && oc version \
    && wget https://github.com/IBM/cloud-pak-cli/releases/latest/download/cloudctl-linux-amd64.tar.gz \
    && gzip -d cloudctl-linux-amd64.tar.gz \
    && tar -xvf cloudctl-linux-amd64.tar \
    && mv cloudctl-linux-amd64 /usr/local/bin/cloudctl \
    && cloudctl version

COPY installcp4i.sh /root

RUN chmod 755 /root/installcp4i.sh

 
# To Build
# docker build -t cp4i:latest -f Dockerfile .
#
# To Run
# docker run -i -t cp4i bash
# 
# In the container login to OCP using the oc command then
# /root/installcp4i.sh


