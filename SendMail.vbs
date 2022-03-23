Const cdoSendUsingPickup = 1 'Send message using the local SMTP service pickup directory. 
Const cdoSendUsingPort = 2 'Send the message using the network (SMTP over the network). 

Const cdoAnonymous = 0 'Do not authenticate
Const cdoBasic = 1 'basic (clear-text) authentication
Const cdoNTLM = 2 'NTLM

Dim M_from,M_to,M_cc,M_Subject,CNT_Attachments,M_File,M_CharSet,M_Body,M_MailFormat,M_BodyFormat
M_from = "zabbix4@stkcn.com"
'M_from = "sc_siemens@sohu.com"
M_to = "baber.huang@softtek.com"
'M_cc = "baber.huang@softtek.com"
M_Subject = "看一下邮件能发吗"
CNT_Attachments=0
M_CharSet="GB2312"
M_Body = "测试邮件是否能发"
M_MailFormat = 0
M_BodyFormat=0

'Dim fso,file,filestream 'fso As New FileSystemObject
'Set fso=CreateObject("scripting.FileSystemObject")
'set file =  fso.OpenTextFile(M_Body,1)
'Content= file.ReadAll()

Set objMessage = CreateObject("CDO.Message") 
objMessage.Subject = M_Subject 
objMessage.From = M_from
objMessage.To = M_to 
objMessage.Cc = M_cc
objMessage.HtmlBody = "test message relay function..."

'==This section provides the configuration information for the remote SMTP server.

objMessage.Configuration.Fields.Item _
("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 

'Name or IP of Remote SMTP Server
objMessage.Configuration.Fields.Item _
("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "uatweb1"

'Type of authentication, NONE, Basic (Base64 encoded), NTLM
objMessage.Configuration.Fields.Item _
("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = cdoBasic

'Server port (typically 25)
objMessage.Configuration.Fields.Item _
("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 

'Use SSL for the connection (False or True)
objMessage.Configuration.Fields.Item _
("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = False

'Connection Timeout in seconds (the maximum time CDO will try to establish a connection to the SMTP server)
objMessage.Configuration.Fields.Item _
("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60

objMessage.Configuration.Fields.Update

'==End remote SMTP server configuration section==

objMessage.Send

set objMessage = nothing