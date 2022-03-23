NameSpace = "http://schemas.microsoft.com/cdo/configuration/"  
Set Email = CreateObject("CDO.Message")  
Email.From = "testsmtp@test.com"  
Email.To = "baber.huang@softtek.com"
'Email.CC = "china.infrastructure@alere.com"  
Email.Subject = "test smtp relay from testing server"  
Email.BodyPart.Charset = "gb2312" 
Email.Textbody = "OK!this is a test message by vbs CDO abc"  
Email.Configuration.Fields.Item(NameSpace &"sendusing") = 2  
Email.Configuration.Fields.Item(NameSpace & "smtpserver")= "10.0.0.4"  
Email.Configuration.Fields.Item(NameSpace & "smtpserverport")= 25 
Email.Configuration.Fields.Item(NameSpace & "smtpauthenticate") = 1
Email.Configuration.Fields.Item(NameSpace & "sendusername") = ""
Email.Configuration.Fields.Item(NameSpace & "sendpassword") = ""
Email.Configuration.Fields.Update  
Email.Send
msgbox "done"