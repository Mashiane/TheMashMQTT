B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.8
@EndOfDesignText@
Sub Class_Globals
	Private misdirty As Boolean = False
	Private mtopic As String
	Private mpayload As String
	Private mqos As Int
	Private mretain As Boolean
End Sub

'initialize the will
Public Sub Initialize
	'does not have content
	misdirty = False
End Sub

'get IsDirty
Sub getIsDirty As Boolean
	Return misdirty
End Sub

'set the topic
Sub settopic(vtopic As String)
	mtopic = vtopic
	misdirty = True
End Sub

'get the topic
Sub gettopic As String
	Return mtopic
End Sub

'set the payload
Sub setpayload(vpayload As String)
	mpayload = vpayload
	misdirty = True
End Sub

'get the payload
Sub getpayload As String
	Return mpayload
End Sub

'set the QoS
Sub setQoS(vqos As Int)
	mqos = vqos
	misdirty = True
End Sub

'get the qos
Sub getQoS As Int
	Return mqos
End Sub

'set retain
Sub setretain(vretain As Boolean)
	mretain = vretain
	misdirty = True
End Sub

'get retain
Sub getretain As Boolean
	Return mretain
End Sub

'get the will structure
Sub getOptions As Map
	Dim opts As Map = CreateMap()
	opts.Put("topic", mtopic)
	opts.Put("payload", mpayload)
	opts.Put("qos", mqos)
	opts.Put("retain", mretain)
	Return opts	
End Sub