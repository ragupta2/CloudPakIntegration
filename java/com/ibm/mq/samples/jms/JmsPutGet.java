/*
* (c) Copyright IBM Corporation 2018
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

package com.ibm.mq.samples.jms;


import javax.jms.Destination;
import javax.jms.JMSConsumer;
import javax.jms.JMSContext;
import javax.jms.JMSException;
import javax.jms.JMSProducer;
import javax.jms.TextMessage;

import com.ibm.msg.client.jms.JmsConnectionFactory;
import com.ibm.msg.client.jms.JmsFactoryFactory;
import com.ibm.msg.client.wmq.WMQConstants;

public class JmsPutGet {

	// System exit status value (assume unset value to be 1)
	private static int status = 1;

	// Create variables for the connection to MQ
	private static final String HOST = "nativeha-ini-qm-ibm-mq-qm-mq.itzroks-550004s7y8-gwvb8u-4b4a324f027aea19c5cbc0c3275c4656-0000.us-south.containers.appdomain.cloud"; // Host name or IP address
	private static final int PORT = 443; // Listener port for your queue manager
	private static final String CHANNEL = "EXT.CONN2"; // Channel name
	private static final String QMGR = "QUICKSTART"; // Queue manager name
	private static final String APP_USER = "app"; // User name that application uses to connect to MQ
	private static final String APP_PASSWORD = "password"; // Password that the application uses to connect to MQ
	private static final String QUEUE_NAME = "IN"; // Queue that the application uses to put and get messages to and from


	/**
	 * Main method
	 *
	 * @param args
	 */
	public static void main(String[] args) {

		// Variables
		JMSContext context = null;
		Destination destination = null;
		JMSProducer producer = null;
		JMSConsumer consumer = null;
		try {
			// Create a connection factory
			JmsFactoryFactory ff = JmsFactoryFactory.getInstance(WMQConstants.WMQ_PROVIDER);
			JmsConnectionFactory cf = ff.createConnectionFactory();

			// Set the properties
			cf.setStringProperty(WMQConstants.WMQ_HOST_NAME, HOST);
			cf.setIntProperty(WMQConstants.WMQ_PORT, PORT);
			cf.setStringProperty(WMQConstants.WMQ_CHANNEL, CHANNEL);
			cf.setIntProperty(WMQConstants.WMQ_CONNECTION_MODE, WMQConstants.WMQ_CM_CLIENT);
			cf.setStringProperty(WMQConstants.WMQ_QUEUE_MANAGER, QMGR);
			cf.setStringProperty(WMQConstants.WMQ_APPLICATIONNAME, "JmsPutGet (JMS)");
			cf.setBooleanProperty(WMQConstants.USER_AUTHENTICATION_MQCSP, true);
			cf.setStringProperty(WMQConstants.USERID, APP_USER);
			cf.setStringProperty(WMQConstants.PASSWORD, APP_PASSWORD);
			cf.setStringProperty(WMQConstants.WMQ_SSL_CIPHER_SUITE, "*TLS12");

			// Create JMS objects
			context = cf.createContext();
			destination = context.createQueue("queue:///" + QUEUE_NAME);
			producer = context.createProducer();

			while (true){
				long uniqueNumber = System.currentTimeMillis() % 1000;
				TextMessage message = context.createTextMessage("Your lucky number today is " + uniqueNumber);
				producer.send(destination, message);
				System.out.println("Sent message:\n" + message);
				recordSuccess();
				try {
					Thread.sleep(5000);
				}
				catch (Exception e)
				{
					System.out.println(e);
				}
			}

			
		} catch (JMSException jmsex) {
			recordFailure(jmsex);
		}

		System.exit(status);

	} // end main()


	private static void recordSuccess() {
		System.out.println("SUCCESS");
		status = 0;
		return;
	}

	/**
	 * Record this run as failure.
	 *
	 * @param ex
	 */
	private static void recordFailure(Exception ex) {
		if (ex != null) {
			if (ex instanceof JMSException) {
				processJMSException((JMSException) ex);
			} else {
				System.out.println(ex);
			}
		}
		System.out.println("FAILURE");
		status = -1;
		return;
	}

	/**
	 * Process a JMSException and any associated inner exceptions.
	 *
	 * @param jmsex
	 */
	private static void processJMSException(JMSException jmsex) {
		System.out.println(jmsex);
		Throwable innerException = jmsex.getLinkedException();
		if (innerException != null) {
			System.out.println("Inner exception(s):");
		}
		while (innerException != null) {
			System.out.println(innerException);
			innerException = innerException.getCause();
		}
		return;
	}

}
