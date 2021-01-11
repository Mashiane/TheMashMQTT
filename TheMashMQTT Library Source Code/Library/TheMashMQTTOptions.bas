B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.8
@EndOfDesignText@
Sub Class_Globals
	Private mkeepalive As Int = 60
	Private mclientId As String
	Private mprotocolId As String = "MQTT"
	Private mprotocolVersion As Int = 4
	Private mclean As Boolean = True
	Private mreconnectPeriod As Int = 1000
	Private mconnectTimeout As Int = 30 * 1000
	Public will As TheMashMQTTWill
	Private mIsDirty As Boolean
	Private musername As String = ""
	Private mpassword As String = ""
	Private mqueueQoSZero As Boolean = True
	Private mreschedulePings As Boolean = True	
	Private mclientId As String
	Private mresubscribe As Boolean
End Sub

'initialize the options
Public Sub Initialize
	'initialize the will
	will.Initialize
	mIsDirty = False
End Sub

'set resubscribe - if connection is broken and reconnects, subscribed topics are automatically subscribed again (default true)
Sub setresubscribe(vresubscribe As Boolean)
	mresubscribe = vresubscribe
	mIsDirty = True
End Sub

'get resubscribe
Sub getmresubscribe As Boolean
	Return mresubscribe
End Sub

'set the client id
Sub setclientID(clientid As String)
	mclientId = clientid
End Sub

'get the client id
Sub getclientID As String
	Return mclientId
End Sub

'set reschedulePings - reschedule ping messages after sending packets (default true)
Sub setreschedulePings(vreschedulePings As Boolean)
	mreschedulePings = vreschedulePings
	mIsDirty = True
End Sub

Sub getreschedulePings As Boolean
	Return mreschedulePings
End Sub

'set queueQoSZero - if connection is broken, queue outgoing QoS zero messages (default true)
Sub setqueueQoSZero(vqueueQoSZero As Boolean)
	mqueueQoSZero = vqueueQoSZero
	mIsDirty = True
End Sub

'get queueQoSZero
Sub getqueueQoSZero As Boolean
	Return mqueueQoSZero
End Sub

'set the password - the password required by your broker, if any
Sub setpassword(pwd As String)
	mpassword = pwd
	mIsDirty = True
End Sub

'get the password
Sub getpassword As String
	Return mpassword
End Sub

'set the username - the username required by your broker, if any
Sub setuserName(usrname As String)
	musername = usrname
	mIsDirty = True
End Sub

'get username
Sub getuserName As String
	Return musername
End Sub


'get IsDirty
Sub getIsDirty As Boolean
	Return mIsDirty
End Sub

'set keep alive - heartbeat time, default 60 seconds, set 0 to disabled.
Sub setkeepalive(vkeepalive As Int)
	mkeepalive = vkeepalive
	mIsDirty = True
End Sub

'get keep alive
Sub getkeepalive As Int
	Return mkeepalive
End Sub

'set protocolId
Sub setprotocolId(vprotocolId As String)
	mprotocolId = vprotocolId
	mIsDirty = True
End Sub

'get the protocolid
Sub getprotocolId As String
	Return mprotocolId
End Sub

'set the protocolVersion
Sub setprotocolVersion(vprotocolVersion As Int)
	mprotocolVersion = vprotocolVersion
	mIsDirty = True
End Sub

'get the protocol version
Sub getprotocolVersion As Int
	Return mprotocolVersion
End Sub

'set clean - set to false to receive QoS 1 and 2 messages while offline.
Sub setclean(vclean As Boolean)
	mclean = vclean
	mIsDirty = True
End Sub

'get clean
Sub getclean As Boolean
	Return mclean
End Sub

'set reconnect period - 1000 milliseconds, interval between two reconnections. Disable auto reconnect by setting to 0.
Sub setreconnectPeriod(vreconnectPeriod As Int)
	mreconnectPeriod = vreconnectPeriod
	mIsDirty = True
End Sub

'get reconnect period
Sub getreconnectPeriod As Int
	Return mreconnectPeriod
End Sub

'set connectTimeout - 30 * 1000 milliseconds, time to wait before a CONNACK is received
Sub setconnectTimeout(vconnectTimeout As Int)
	mconnectTimeout = vconnectTimeout
	mIsDirty = True
End Sub

'get connectTimeout
Sub getconnectTimeout As Int
	Return mconnectTimeout
End Sub

'get options
Sub getOptions As Map
	Dim opts As Map = CreateMap()
	opts.Put("keepalive", mkeepalive)
	opts.Put("clientId", mclientId)
	opts.Put("protocolId", mprotocolId)
	opts.Put("protocolVersion", mprotocolVersion)
	opts.Put("clean", mclean)
	opts.put("reconnectPeriod", mreconnectPeriod)
	opts.Put("connectTimeout", mconnectTimeout)
	opts.Put("queueQoSZero", mqueueQoSZero)
	opts.Put("reschedulePings", mreschedulePings)
	opts.Put("clientId", mclientId)
	opts.Put("resubscribe", mresubscribe)
	If musername <> "" Then
		opts.Put("username", musername)
	End If
	If mpassword <> "" Then
		opts.Put("password", mpassword)
	End If
	If will.IsDirty Then
		opts.Put("will", will.Options)
		mIsDirty = True
	End If
	Return opts
End Sub