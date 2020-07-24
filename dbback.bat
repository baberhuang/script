net stop mysql
xcopy "C:\ProgramData\MySQL\MySQL Server 5.6\data\nic\*.*" E:\nicdbbackup\%date:~0,10%\ /S /I
net start mysql