@Echo off
 net use \\172.20.20.57 /u:test1 password
 set User=sa
 set Password=password
 set sqlstore=E:\ProductDB\APAC_US\CHINA
 set sqlbak=%sqlstore%\BAK
 set websqlstore=\\172.20.20.57\ProductDB\APAC_US\CHINA
 set websqlbak=%websqlstore%\BAK