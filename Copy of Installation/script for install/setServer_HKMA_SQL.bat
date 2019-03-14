@Echo off
 net use \\172.20.20.57 /u:test1 password
 rem set DBServer=172.20.20.57\SQL2008R2
 set User=sa
 set Password=password

rem  set sqlstore=F:\SQL2008\APAC DB\HKMA
rem  set sqlbak=%sqlstore%\BAK
rem set websqlstore=\\172.20.20.55\sql2008\APAC DB\HKMA
rem  set websqlbak=%websqlstore%\BAK
 
 set sqlstore=E:\ProductDB\APAC_US\HKMA
 set sqlbak=%sqlstore%\BAK
 set websqlstore=\\172.20.20.57\ProductDB\APAC_US\HKMA
 set websqlbak=%websqlstore%\BAK