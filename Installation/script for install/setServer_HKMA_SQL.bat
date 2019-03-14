@Echo off
 net use \\172.20.20.55 /u:test1 password
 set DBServer=172.20.20.55\stbbc
 set User=sa
 set Password=password
 set sqlstore=E:\hkma\SQLSERVER2005
 set sqlbak=%sqlstore%\BAK
 set websqlstore=\\172.20.20.55\hkma\SQLSERVER2005
 set websqlbak=%websqlstore%\BAK