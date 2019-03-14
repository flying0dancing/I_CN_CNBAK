@Echo off
 net use \\172.20.20.55 /u:test1 password
 set DBServer=172.20.20.55\sql2008
 set User=sa
 set Password=password
 set sqlstore=E:\CN_4201\SQLServer2008
 set sqlbak=%sqlstore%\BAK
 set websqlstore=\\172.20.20.55\CN_4201\SQLServer2008
 set websqlbak=%websqlstore%\BAK