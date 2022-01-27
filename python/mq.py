import pymqi

queue_manager = 'QUICKSTART'
queue_name = 'IN'
message = 'Hello from Python!'

cd = pymqi.CD()
cd.ChannelName = 'EXT.CONN'.encode('utf-8')
cd.ConnectionName = '<your-qm-route>(443)'.encode('utf-8')
cd.ChannelType = pymqi.CMQC.MQCHT_CLNTCONN
cd.TransportType = pymqi.CMQC.MQXPT_TCP

cd.SSLCipherSpec = 'ANY_TLS12'.encode('utf-8')
sco = pymqi.SCO()
sco.KeyRepository = '/<path-to-certs>/clientkey'.encode('utf-8')
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