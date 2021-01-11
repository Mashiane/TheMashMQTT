B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.5
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Public app As HTMLApp
	Private banano As BANano
	Private mqtt As TheMashMQTTClient
	Private lblConnected As HTMLElement
	Private btnConnect As HTMLElement
	Private txtLogs As HTMLElement
	Private isConnected As Boolean
	Private lblClientID As HTMLElement
	Private lblNextID As HTMLElement
	Private btnDisconnect As HTMLElement
	Private btnSendMessage As HTMLElement
	Private txtTopic As HTMLElement
	Private txtMessage As HTMLElement
	Private btnUnsubscribe As HTMLElement
	Private btnSubscribe As HTMLElement
	Private btnSend As HTMLElement
	Private txtProtocol As HTMLElement
	Private txtBroker As HTMLElement
	Private txtPort As HTMLElement
	Private txtPath As HTMLElement
End Sub

Sub Init
	app.Initialize
	'
	Dim cont As HTMLElement = app.AddContainer(Me, "#body", "cont")
	cont.BorderRadius = "5px"
	cont.Color = app.COLOR_GREY
	cont.ColorIntensity = app.INTENSITY_LIGHTEN1
	cont.PA = "20px"
	'
	cont.Fluid = True
	cont.AddRows1.AddColumns12   'R1
	cont.AddRows1.AddColumns6x2	 'R2
	cont.AddRows1.AddColumns3x4  'R3
	cont.AddRows1.AddColumns4.AddColumns6.AddColumns2  'R4
	cont.AddRows1.AddColumns2.AddColumns2  'R5
	cont.AddRows1.AddColumns12   'R6
	'cont.ShowGridDesign = True
	cont.BuildGrid
	
	'R1
	app.AddH1(Me, cont.MatrixID(cont.NextRow,1), "info", "Playing MQTT.js")
	app.AddParagraph(Me, cont.MatrixID(cont.ThisRow, 1), "p1", "Public MQTT Brokers...")
	app.AddParagraph(Me, cont.MatrixID(cont.ThisRow, 1), "p2", "ws *** broker.emqx.io *** 8083 *** /mqtt")
	app.AddParagraph(Me, cont.MatrixID(cont.ThisRow, 1), "p3", "ws *** broker.mqtt-dashboard.com *** 8000 *** /mqtt")
	app.AddParagraph(Me, cont.MatrixID(cont.ThisRow, 1), "p4", "ws *** broker.hivemq.com *** 8000 *** /mqtt")
	
	'R2
	txtProtocol = app.AddTextBox(Me, cont.MatrixID(cont.NextRow, 1), "xprotocol")
	txtProtocol.Value = "ws"
	
	txtBroker = app.AddTextBox(Me, cont.MatrixID(cont.ThisRow, 2), "xbroker")
	txtBroker.Value = "broker.emqx.io"
	
	txtPort = app.AddTextBox(Me, cont.MatrixID(cont.ThisRow, 3), "xport")
	txtPort.Value = "8083"
	
	txtPath = app.AddTextBox(Me, cont.MatrixID(cont.ThisRow, 4), "xpath")
	txtPath.Value = "/mqtt"
	
	lblConnected = app.AddParagraph(Me, cont.MatrixID(cont.ThisRow, 5), "xconnected", "Connected: False")
	btnConnect = app.AddButton(Me, cont.MatrixID(cont.ThisRow, 6), "btnConnect", "Connect")
	StyleButton(btnConnect)
	btnConnect.Color = app.COLOR_LIGHTGREEN
	'R3
	lblClientID = app.AddParagraph(Me, cont.MatrixID(cont.NextRow, 1), "xclientid", "ClientID: ")
	lblNextID = app.AddParagraph(Me, cont.MatrixID(cont.ThisRow, 2), "xnextid", "NextID: ")
	btnDisconnect = app.AddButton(Me, cont.MatrixID(cont.ThisRow, 3), "btnDisconnect", "Disconnect")
	StyleButton(btnDisconnect)
	btnDisconnect.Color = app.COLOR_RED
	
	'R4
	txtTopic = app.AddTextBox(Me, cont.MatrixID(cont.NextRow, 1), "txtTopic")
	txtTopic.Placeholder = "Topic"
	txtTopic.Value = "testtopic"
	StyleText(txtTopic)
	'
	txtMessage = app.AddTextBox(Me, cont.MatrixID(cont.ThisRow, 2), "txtMessage")
	txtMessage.Placeholder = "Message"
	txtMessage.Value = "ws connection demo...!"
	StyleText(txtMessage)
	'
	btnSend = app.AddButton(Me, cont.MatrixID(cont.ThisRow, 3), "btnSend", "Send")
	StyleButton(btnSend)
	btnSend.Color = app.COLOR_BROWN
	'
	'R5
	btnSubscribe = app.AddButton(Me, cont.MatrixID(cont.NextRow, 1), "btnSubscribe", "Subscribe")
	StyleButton(btnSubscribe)
	btnSubscribe.Color = app.COLOR_BLUE 
	
	btnUnsubscribe = app.AddButton(Me, cont.MatrixID(cont.ThisRow, 2), "btnUnsubscribe", "Un-subscribe")
	StyleButton(btnUnsubscribe)
	btnUnsubscribe.Color = app.COLOR_ORANGE
	
	'R6
	txtLogs = app.AddTextArea(Me, cont.MatrixID(cont.NextRow, 1), "txtlogs", "")
	txtLogs.AddStyle("width", "100%").AddStyle("height", "500px")
	txtLogs.ResizeNone = True
	txtLogs.BorderNone = True
	txtLogs.OutlineNone = True
	txtLogs.BorderRadius = "4px"
	'
	isConnected = False
End Sub

Sub btnSubscribe_click(e As BANanoEvent)
	txtLogs.appendNewLine
	txtLogs.appendValue($"Subscribe to topic '${txtTopic.value}'"$)
	mqtt.subscribe(txtTopic.Value, mqtt.QOS_AT_LEAST_ONCE)
End Sub

Sub btnSend_click(e As BANanoEvent)
	txtLogs.appendNewLine
	txtLogs.appendValue("Send Own Message...")
	mqtt.publish(txtTopic.Value, txtMessage.Value, mqtt.QOS_AT_LEAST_ONCE, False, False)
End Sub

Sub btnUnsubscribe_click(e As BANanoEvent)
	txtLogs.appendNewLine
	txtLogs.appendValue($"Un-Subscribe (${txtTopic.Value})..."$)
	mqtt.unsubscribe(txtTopic.Value)
End Sub

Sub StyleText(txt As HTMLElement)
	txt.BorderNone = True
	txt.FitBlock = True
	txt.BorderRadius = "4px"
	txt.MB = "16px"
	txt.PY = "8px"
	txt.PX = "16px"
	txt.OutlineNone = True
End Sub

Sub StyleButton(btn As HTMLElement)
	btn.CursorPointer = True
	btn.BorderNone = True
	btn.FitBlock = True
	btn.TextColor = app.COLOR_WHITE
	btn.BorderRadius = "4px"
	btn.MB = "16px"
	btn.PY = "8px"
	btn.PX = "16px"
	btn.WhiteSpaceNoWrap = True
	btn.TextAlighCenter = True
	btn.TextDecorationNone = True
	btn.VerticalAlignMiddle = True
	btn.OutlineNone = True
End Sub

Sub CheckConnection
	'check the connection state
	isConnected = mqtt.connected
	'update the state display
	lblConnected.Text = $"Connected: ${isConnected}"$
End Sub

'click the disconnect button
Sub btnDisconnect_click(e As BANanoEvent)
	txtLogs.appendNewLine
	txtLogs.appendValue("Disconnect...")
	mqtt.close(True)
End Sub

'click the connect button
Sub btnConnect_click(e As BANanoEvent)
	txtLogs.appendNewLine
	txtLogs.appendValue("Connect...")
	'reset the connection status
	lblConnected.Text = "Connected: False"
	lblClientID.Text = "ClientID: "
	lblNextID.Text = "NextID: "
	'define a client id
	Dim clientId As String = "TheMashMQTT_" & Rnd(1,9999999999)
	'initialize mqtt
	mqtt.Initialize(Me, "mqtt")
	mqtt.Protocol = txtProtocol.value
	mqtt.Broker = txtBroker.value
	mqtt.Port = txtPort.value
	mqtt.Path = txtPath.value
	'
	Dim options As TheMashMQTTOptions = mqtt.options
	'START OF DEFAULT VALUES (NOT NECESSARY)
	options.keepalive = 60
	options.clientId = clientId
	options.protocolId = "MQTT"
	options.protocolVersion = 4
	options.clean = True
	options.reconnectPeriod = 1000
	options.connectTimeout = 30 * 1000
	'END OF DEFAULT VALUES
	options.resubscribe = True
	'	
	Dim will As TheMashMQTTWill = options.will
	will.topic = "WillMsg"
	will.payload = "Connection Closed abnormally..!"
	will.qos = 0
	will.retain = False
	'connect
	mqtt.connect
	'
	Log(mqtt.host)
End Sub

'when connected
Sub mqtt_onconnect(connack As Map)
	txtLogs.appendNewLine
	txtLogs.appendValue("Connected...")
	Dim sconnack As String = banano.ToJson(connack)
	txtLogs.appendValue(sconnack)
	CheckConnection
	lblClientID.Text = $"ClientID: ${mqtt.clientID}"$
	lblNextID.Text = $"NextID: ${mqtt.nextId}"$
	'
	'subscribe to a topic
	txtLogs.appendNewLine
	txtLogs.appendValue($"Subscribe to '${txtTopic.value}' QoS (at least once)..."$)
	mqtt.subscribe(txtTopic.value, mqtt.QOS_AT_LEAST_ONCE)
End Sub

'when message is published
Sub mqtt_onpublish(err As Object)
	txtLogs.appendNewLine
	txtLogs.appendValue("On Publish...")
	Log("onpublish")
	If banano.IsNull(err) Or banano.IsUndefined(err) Then
	Else
		txtLogs.appendNewLine
		txtLogs.appendValue("Publish Error...")
		Log("error-p")
		Log(err)
		Dim serror As String = banano.ToJson(err)
		txtLogs.appendValue(serror)
	End If
End Sub

'when subscription happens on a topic
Sub mqtt_onsubscribe(err As Object, granted As Object)
	txtLogs.appendNewLine
	txtLogs.appendValue("On Subscribe...")
	Log("onsubscribe")
	If banano.IsNull(err) Or banano.IsUndefined(err) Then
	Else
		txtLogs.appendNewLine
		txtLogs.appendValue("Subscription Error...")
		Log("error-s")
		Log(err)
		Dim serror As String = banano.ToJson(err)
		txtLogs.appendValue(serror)
	End If
	If banano.IsNull(granted) Or banano.IsUndefined(granted) Then
	Else
		txtLogs.appendNewLine
		txtLogs.appendValue("Subscription Granted...")
		Log("granted-s")
		Dim sgranted As String = banano.ToJson(granted)
		txtLogs.appendValue(sgranted)
		Log(granted)
		'
		'publish a message to a topic
		txtLogs.appendNewLine
		txtLogs.appendValue($"Publish a message to '${txtTopic.value}' QoS (at least once)..."$)
		mqtt.publish(txtTopic.value, txtMessage.value, mqtt.QOS_AT_LEAST_ONCE, False, False)
	End If
End Sub

'when an error happens
Sub mqtt_onerror(err As Object)
	txtLogs.appendNewLine
	txtLogs.appendValue("On Error...")
	If banano.IsNull(err) Or banano.IsUndefined(err) Then
	Else	
		Log("error")
		Log(err)
		txtLogs.appendNewLine
		txtLogs.appendValue("When an error happens, force close the connection...")
		mqtt.close(True)
	End If
End Sub

'when a message arrives
Sub mqtt_onmessage(topic As String, message As Object, packet As Object)
	txtLogs.appendNewLine
	txtLogs.appendValue("Message...")
	Log("message")
	Dim smessage As String = mqtt.getMessage(message)
	Dim msg As Map = CreateMap()
	msg.Put("topic", topic)
	msg.Put("message", smessage)
	txtLogs.appendValue(banano.ToJson(msg))
End Sub


'when closed
Sub mqtt_onclose
	Log("close")
	txtLogs.appendNewLine
	txtLogs.appendValue("Closed...")
	CheckConnection
End Sub


'when reconnect
Sub mqtt_onreconnect
	txtLogs.appendNewLine
	txtLogs.appendValue("Reconnecting...")
	Log("reconnect...")
	CheckConnection
End Sub

'when disconnected
Sub mqtt_ondisconnect(packet As Object)
	txtLogs.appendNewLine
	txtLogs.appendValue("Disconnect...")
	Log("disconnect")
	Log(packet)
	CheckConnection
End Sub

'when offline
Sub mqtt_onoffline(packet As Object)
	txtLogs.appendNewLine
	txtLogs.appendValue("Offline...")
	Log("offline...")
	Log(packet)
	CheckConnection
End Sub

'when end
Sub mqtt_onend()
	txtLogs.appendNewLine
	txtLogs.appendValue("End...")
	CheckConnection
	Log("end...")
End Sub

'on unsubscribed
Sub mqtt_onunsubscribe(err As Map)
	txtLogs.appendNewLine
	txtLogs.appendValue("On Un-Subscribed...")
	Log(err)
End Sub