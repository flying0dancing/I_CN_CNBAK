@Echo off
 net use \\172.20.20.55\cn_4201 /u:test1 password
set DBServer=172.20.20.55\sql2008
 set User=sa
 set Password=password
 set sqlstore=E:\CN_4201\SQLServer2008
 set sqlbak=E:\CN_4201\SQLServer2008\BAK
rem set DBServer=.
rem set User=sa
rem set Password=password
rem set sqlstore=C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA
rem set sqlbak=D:\SQLSERVERBAK