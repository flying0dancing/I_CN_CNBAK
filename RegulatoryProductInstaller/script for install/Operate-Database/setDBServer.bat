@Echo off
 net use \\172.20.20.55 /u:test1 password
 set DBServer=172.20.20.55\stbbc
 set User=sa
 set Password=password
 set sqlstore=F:\SQL2008\APAC DB\HKMA
 set sqlbak=%sqlstore%\BAK
 set websqlstore=\\172.20.20.55\sql2008\APAC DB\HKMA
 set websqlbak=%websqlstore%\BAK
rem set DBServer=.
rem set User=sa
rem set Password=password
rem set sqlstore=C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA
rem set sqlbak=D:\SQLSERVERBAK