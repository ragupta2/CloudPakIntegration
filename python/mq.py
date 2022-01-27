import pymqi

queue_manager = 'QUICKSTART'
queue_name = 'IN'
message = 'Hello from Python!'

cd = pymqi.CD()
cd.ChannelName = 'EXT.CONN2'.encode('utf-8')
cd.ConnectionName = 'nativeha-ini-qm-ibm-mq-qm-mq.itzroks-550004s7y8-gwvb8u-4b4a324f027aea19c5cbc0c3275c4656-0000.us-south.containers.appdomain.cloud(443)'.encode('utf-8')
cd.ChannelType = pymqi.CMQC.MQCHT_CLNTCONN
cd.TransportType = pymqi.CMQC.MQXPT_TCP

cd.SSLCipherSpec = 'ANY_TLS12'.encode('utf-8')
sco = pymqi.SCO()
sco.KeyRepository = '/Users/jackyng/Desktop/Learning/mq-learning/mq-golang-tls-doc/ssl/clientkey'.encode('utf-8')
sco.CertificateLabel = 'ibmwebspheremqapp'.encode('utf-8')

qmgr = pymqi.QueueManager(None)
qmgr.connect_with_options(queue_manager, user='app', password='password', cd=cd, sco=sco )

put_queue = pymqi.Queue(qmgr, queue_name)
put_queue.put(message)

get_queue = pymqi.Queue(qmgr, queue_name)
print(get_queue.get())

put_queue.close()
get_queue.close()

qmgr.disconnect()