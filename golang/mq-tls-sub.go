package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/ibm-messaging/mq-golang/v5/ibmmq"
)

var qMgrName string
var qName string
var err error
var qMgr ibmmq.MQQueueManager
var rc int
var qObject ibmmq.MQObject
var subscriptionObject ibmmq.MQObject
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
	subMessage(qMgr)

	fmt.Println("Done.")
	// qObject.Close(0)
	subscriptionObject.Close(0)
	qMgr.Disc()
	os.Exit(rc)
	
}

func subMessage(qMgrObject ibmmq.MQQueueManager) {

	mqsd := ibmmq.NewMQSD()
	mqsd.Options = ibmmq.MQSO_CREATE |
			ibmmq.MQSO_NON_DURABLE |
			ibmmq.MQSO_MANAGED

	mqsd.ObjectString = topicString

	subscriptionObject, err = qMgrObject.Sub(mqsd, &qObject)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println("Subscription made to topic ", topicString)
	}

	msgAvail := true
	for msgAvail == true && err == nil {
		var datalen int

		// The GET requires control structures, the Message Descriptor (MQMD)
		// and Get Options (MQGMO). Create those with default values.
		getmqmd := ibmmq.NewMQMD()
		gmo := ibmmq.NewMQGMO()

		// The default options are OK, but it's always
		// a good idea to be explicit about transactional boundaries as
		// not all platforms behave the same way.
		gmo.Options = ibmmq.MQGMO_NO_SYNCPOINT

		// Set options to wait for a maximum of 3 seconds for any new message to arrive
		gmo.Options |= ibmmq.MQGMO_WAIT
		gmo.WaitInterval = 100 * 1000 // The WaitInterval is in milliseconds

		// Create a buffer for the message data. This one is large enough
		// for the messages put by the amqsput sample.
		buffer := make([]byte, 1024)

		// Now we can try to get the message
		datalen, err = qObject.Get(getmqmd, gmo, buffer)

		if err != nil {
			msgAvail = false
			fmt.Println(err)
			mqret := err.(*ibmmq.MQReturn)
			if mqret.MQRC == ibmmq.MQRC_NO_MSG_AVAILABLE {
				// If there's no message available, then I won't treat that as a real error as
				// it's an expected situation
				err = nil
			}
		} else {
			// Assume the message is a printable string, which it will be
			// if it's been created by the amqspub program
			fmt.Printf("Got message of length %d: ", datalen)
			fmt.Println(strings.TrimSpace(string(buffer[:datalen])))
		}
	}
}

