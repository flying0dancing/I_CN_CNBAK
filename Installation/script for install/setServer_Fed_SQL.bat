@Echo off
 net use \\172.20.20.55 /u:test1 password
 set DBServer=172.20.20.55\sql2008
 set User=sa
 set Password=password
 set sqlstore=F:\SQL2008\QADB
 set sqlbak=F:\SQL2008\QADB
 set websqlstore=\\172.20.20.55\SQL2008\QADB
 set websqlbak=\\172.20.20.55\SQL2008\QADB