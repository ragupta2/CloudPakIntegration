# Commands to run


- Create the imagestream.
`oc apply -f imagestream.yaml`

- Create the BuildConfig.
`oc apply -f buildconfig.yaml`

- Start a new build from the BuildConfig.
`oc start-build mq-java-app-build`

- Once the build is finished, create a secret to house the  `.jks` certificate either with the `cert-secret.yaml` or with the following command.
```s
oc create secret generic mq-java-tls-secret --from-file=mq-java-tls.jks=/path/to/mq-java-tls.jks
```  

- Edit the Deployment yaml if needed to update the correct names of the secret. Apply the Deployment.
`oc apply -f deployment.yaml`