## Connect to QM using Java

Description: You can run Java locally or in container to connect to MQ. This tutorial shows you how to spin up a container with MQ JMS client and send sample messages to a queue. You can edit the sample messages in your java files under directory: `com/ibm/mq/samples/jms/`.
For example, currently "put" program is sending sample messages constantly in a loop. If you want to edit sample messages go to `com/ibm/mq/samples/jms/JMSPutGet.java` file and the while loop around line 86

### Steps

```
git clone https://github.com/ragupta2/CloudPakIntegration.git
cd CloudPakIntegration/java

```

- Copy your truststore certificate (JKS) in `certs/` then build and run your container
- Edit truststore password in your Dockerfile in CMD argument with key `-Djavax.net.ssl.trustStorePassword=`
- Edit Dockerfile to use your queue manager details
  - If you are not using credentials or cipherSuite then comment out those configurations in `com/ibm/mq/samples/jms/JMSPutGet.java` on lines (75, 76, 77)

```
docker build -t mq-java-app -f Dockerfile.put .

```

```
docker run mq-java-app
```

You should be able to see messages on your Queue
