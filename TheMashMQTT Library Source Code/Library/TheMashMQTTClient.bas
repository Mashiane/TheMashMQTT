B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.8
@EndOfDesignText@
Sub Class_Globals
	Public mqtt As BANanoObject
	Private mbroker As String
	Private mport As Int
	Private mcallBack As Object
	Private mEventName As String
	Public const PROTOCOL_WS As String = "ws"
	Public const PROTOCOL_WSS As String = "wss"
	Public const PROTOCOL_MQTTS As String = "mqtts"
	Public const PROTOCOL_WXS As String = "wxs"
	'
	Public const QOS_AT_MOST_ONCE As Int = 0
	Public const QOS_AT_LEAST_ONCE As Int = 1
	Public const QOS_EXACTLY_ONCE As Int = 2
	'
	Public const ERR_ECONNREFUSED As Int = 0
	Public const ERR_ECONNRESET As Int = 1
	Public const ERR_EADDRINUSE As Int = 2
	Public const ERR_ENOTFOUND As Int = 3
	
	Private mpath As String = "/path"
	Private mHost As String
	Private mprotocol As String = "ws"
	Public options As TheMashMQTTOptions	
	Public client As BANanoObject
	Private Banano As BANano
	Private musername As String = ""
	Private mpassword As String = ""
	Private mclientId As String = ""
	Private reconnectmethod As String
	Private errormethod As String
	Private connectmethod As String
	Private closemethod As String
	Private disconnectmethod As String
	Private offlinemethod As String
	Private messagemethod As String
	Private endmethod As String
	Private packetsendmethod As String
	Private packetreceivemethod As String
	Private onsubscribemethod As String
	Private onunsubscribemethod As String
	Private onpublishmethod As String
End Sub

'initialize mqtt with an event name
Public Sub Initialize(Module As Object, event As String)
	mqtt.Initialize("mqtt")
	mEventName = event
	mcallBack = Module
	options.Initialize
	'define the events
	reconnectmethod = $"${mEventName}_onreconnect"$
	errormethod = $"${mEventName}_onerror"$
	connectmethod = $"${mEventName}_onconnect"$
	closemethod = $"${mEventName}_onclose"$
	disconnectmethod = $"${mEventName}_ondisconnect"$
	offlinemethod = $"${mEventName}_onoffline"$
	messagemethod = $"${mEventName}_onmessage"$
	endmethod = $"${mEventName}_onend"$
	packetsendmethod = $"${mEventName}_onpacketsend"$
	packetreceivemethod = $"${mEventName}_onpacketreceive"$
	onsubscribemethod = $"${mEventName}_onsubscribe"$
	onunsubscribemethod = $"${mEventName}_onunsubscribe"$
	onpublishmethod = $"${mEventName}_onpublish"$
End Sub


'connect to the mqtt broker, events raised are
'_onreconnect
'_onerror
'_onconnect
'_onclose
'_ondisconnect
'_onoffline
'_onmessage
'_onpacketsend
'_onpacketreceive
'_onsubscribe
'_onunsubscribe
'_onpublish
Sub connect
	If mpath = "" Then
		mpath = "/path"
	End If
	mHost = $"${mprotocol}://${mbroker}:${mport}${mpath}"$
	Dim opts As Map = CreateMap()
	If options.IsDirty Then
		opts = options.Options
	End If
	'establish the connection
	client = mqtt.RunMethod("connect", Array(mHost, opts))
		
	'specify events to fire	
	Dim cbreconnect As BANanoObject = Banano.CallBack(mcallBack, reconnectmethod, Null)
	Dim err As Object
	Dim cberror As BANanoObject = Banano.CallBack(mcallBack, errormethod, Array(err))
	Dim connack As Object	
	Dim cbconnect As BANanoObject = Banano.CallBack(mcallBack, connectmethod, Array(connack))
	Dim cbclose As BANanoObject = Banano.CallBack(mcallBack, closemethod, Null)
	Dim packet As Object
	Dim cbdisconnect As BANanoObject = Banano.CallBack(mcallBack, disconnectmethod, Array(packet))
	Dim cboffline As BANanoObject = Banano.CallBack(mcallBack, offlinemethod, Array(packet))
	Dim topic As Object
	Dim message As Object
	Dim cbmessage As BANanoObject = Banano.CallBack(mcallBack, messagemethod, Array(topic, message, packet))
	Dim cbpacketsend As BANanoObject = Banano.CallBack(mcallBack, packetsendmethod, Array(packet))
	Dim cbpacketreceive As BANanoObject = Banano.CallBack(mcallBack, packetreceivemethod, Array(packet))
	
	client.RunMethod("on", Array("reconnect", cbreconnect))
	client.RunMethod("on", Array("reconnect", cbreconnect))
	client.RunMethod("on", Array("error", cberror))
	client.RunMethod("on", Array("connect", cbconnect))
	client.RunMethod("on", Array("close", cbclose))
	client.RunMethod("on", Array("disconnect", cbdisconnect))
	client.RunMethod("on", Array("offline", cboffline))
	client.RunMethod("on", Array("message", cbmessage))
	client.RunMethod("on", Array("packetsend", cbpacketsend))
	client.RunMethod("on", Array("packetreceive", cbpacketreceive))
End Sub

'convert payload to string
Sub getMessage(m As BANanoObject) As String
	Dim str As String = m.RunMethod("toString", Null).Result
	Return str
End Sub

'convert payload to string using byte array
Sub getMessageFromBytes(Payload() As Byte) As String
	Dim msg As String = BytesToString(Payload, 0, Payload.Length, "utf8")
	Return msg
End Sub

'publish a message to a topic
Sub publish(topic As String, message As String, iQoS As Int, bRetain As Boolean, bMarkAsDuplicate As Boolean)
	Dim opts As Map = CreateMap()
	opts.Put("qos",iQoS)
	opts.Put("retain", bRetain)
	opts.Put("dup", bMarkAsDuplicate)
	Dim err As Map
	Dim cbPublish As BANanoObject = Banano.CallBack(mcallBack, onpublishmethod, Array(err))
	client.RunMethod("publish", Array(topic, message, opts, cbPublish))
End Sub

'subscribe to a topic
Sub subscribe(topic As String, iQoS As Int)
	Dim opts As Map = CreateMap()
	opts.Put("qos",iQoS)	
	Dim err As Map
	Dim granted As Map
	Dim cbSubscribe As BANanoObject = Banano.CallBack(mcallBack, onsubscribemethod, Array(err, granted))
	client.RunMethod("subscribe", Array(topic, opts, cbSubscribe))
End Sub

'unsubscribe from a topic
Sub unsubscribe(topic As String)	
	Dim opts As Map = CreateMap()
	Dim err As Map
	Dim cbUnSubscribe As BANanoObject = Banano.CallBack(mcallBack, onunsubscribemethod, Array(err))
	client.RunMethod("unsubscribe", Array(topic, opts, cbUnSubscribe))
End Sub

'close the client
Sub close(bForce As Boolean)
	Dim opts As Map = CreateMap()
	Dim cbClose As BANanoObject = Banano.CallBack(mcallBack, endmethod, Null)
	client.RunMethod("end", Array(bForce, opts, cbClose))
End Sub

'set protocol
Sub setProtocol(vconnectionType As String)
	mprotocol = vconnectionType
End Sub

'get protocol
Sub getProtocol As String
	Return mprotocol
End Sub

'get the host
Sub getHost As String
	Return mHost
End Sub

'set the broker
Sub setBroker(broker As String)
	mbroker = broker
End Sub

'get the broker
Sub getBroker As String
	Return mbroker
End Sub

'set the port
Sub setPort(port As Int)
	mport = port
End Sub

'get the port
Sub getPort As Int
	Return mport
End Sub

'set the path
Sub setPath(path As String)
	mpath = path
End Sub

'get the path
Sub getPath As String
	Return mpath
End Sub

'get the connected state
Sub getconnected As Boolean
	Return client.GetField("connected").Result
End Sub

'get the nextId
Sub getnextId As Int
	Return client.GetField("nextId").Result
End Sub

'get the password
Sub getpassword As String
	Return options.password
End Sub

'get username
Sub getuserName As String
	Return options.userName
End Sub

'get the client id
Sub getclientID As String
	Return options.clientID
End Sub

'Remove a message from the outgoingStore
Sub removeOutgoingMessage(mID As Int)
	client.RunMethod("removeOutgoingMessage", Array(mID))
End Sub

'Connect again using the same options as connect
Sub reconnect
	client.RunMethod("reconnect", Null)
End Sub

'get last message id. This is for sent messages only.
Sub getLastMessageId As Int
	Return client.GetField("getLastMessageId").Result
End Sub

'set to true if the client is trying to reconnect to the server.
Sub getreconnecting As Boolean
	Return client.GetField("reconnecting").Result
End Sub