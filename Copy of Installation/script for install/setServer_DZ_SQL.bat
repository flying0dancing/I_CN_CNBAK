@Echo off
 net use \\172.20.20.55 /u:test1 password
 rem set DBServer=172.20.20.55\stbbc
 set User=sa
 set Password=password
 set sqlstore=F:\sql2008\EMEA DB\Integration\DZ
 set sqlbak=%sqlstore%\BAK
 set websqlstore=\\172.20.20.55\sql2008\EMEA DB\Integration\DZ
 set websqlbak=%websqlstore%\BAK