package main

import (
	"fmt"
	"github.com/ibm-messaging/mq-golang/v5/ibmmq"
	"os"
	"time"
)

var qMgrName string
var qName string
var err error
var qMgr ibmmq.MQQueueManager
var rc int
var qObject ibmmq.MQObject
var topicObject ibmmq.MQObject
var topicString string


func main() {

	cno := ibmmq.NewMQCNO()
	sco := ibmmq.NewMQSCO()
	cd := ibmmq.NewMQCD()

	qMgrName = os.Getenv("QUEUE_MANAGER")
	topicString = os.Getenv("TOPIC")
	cd.ChannelName = os.Getenv("CHANNEL")
	cd.ConnectionName = os.Getenv("CONNECTION_URL")
	sco.KeyRepository = os.Getenv("KEY_PATH")

	cd.SSLCipherSpec = "TLS_RSA_WITH_AES_128_CBC_SHA256"
	cd.SSLClientAuth = ibmmq.MQSCA_OPTIONAL

	cno.ClientConn = cd
	cno.Options = ibmmq.MQCNO_CLIENT_BINDING
	cno.SSLConfig = sco

	// Establish a connection
	qMgr, err = ibmmq.Connx(qMgrName, cno)
	// Connection successful
	if err == nil {
		fmt.Printf("Connection to %s succeeded.\n", qMgrName)
		rc = 0
	}

	if err != nil {
		fmt.Printf("Connection to %s failed.\n", qMgrName)
		fmt.Println(err)
		rc = int(err.(*ibmmq.MQReturn).MQCC)
	}

	// Call putMessage function.
	pubMessage(qMgr)

	fmt.Println("Done.")
	// qObject.Close(0)
	qMgr.Disc()
	os.Exit(rc)
	
}

func pubMessage(qMgrObject ibmmq.MQQueueManager) {

	// Open the Topic
	mqod := ibmmq.NewMQOD()
	openOptions := ibmmq.MQOO_OUTPUT

	mqod.ObjectType = ibmmq.MQOT_TOPIC
	mqod.ObjectString = topicString

	topicObject, err = qMgrObject.Open(mqod, openOptions)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println("Opened topic ", topicString)
	}

	// PUBLISH a message to the queue
	if err == nil {
		// The PUT requires control structures, the Message Descriptor (MQMD)
		// and Put Options (MQPMO). Create those with default values.
		putmqmd := ibmmq.NewMQMD()
		pmo := ibmmq.NewMQPMO()

		// The default options are OK, but it's always
		// a good idea to be explicit about transactional boundaries as
		// not all platforms behave the same way.
		pmo.Options = ibmmq.MQPMO_NO_SYNCPOINT

		// Tell MQ what the message body format is. In this case, a text string
		putmqmd.Format = ibmmq.MQFMT_STRING

		// And create the contents to include a timestamp just to prove when it was created
		msgData := "Hello from Go at " + time.Now().Format(time.RFC3339)

		// The message is always sent as bytes, so has to be converted before the PUT.
		buffer := []byte(msgData)

		// Now put the message to the queue
		err = topicObject.Put(putmqmd, pmo, buffer)

		if err != nil {
			fmt.Println(err)
		} else {
			fmt.Println("Published message to", topicString)
		}
	}
}

