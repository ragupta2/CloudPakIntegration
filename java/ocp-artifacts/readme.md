# Commands to run


- Create the imagestream.
`oc apply -f imagestream.yaml`

- Create the BuildConfig.
`oc apply -f buildconfig.yaml`

- Start a new build from the BuildConfig.
`oc start-build mq-java-app-build`

- Once the build is finished, create the Deployment.
`oc apply -f deployment.yaml`