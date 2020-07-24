%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
DEL/q C:\Windows\System32\spool\PRINTERS\*.*
net start Spooler
