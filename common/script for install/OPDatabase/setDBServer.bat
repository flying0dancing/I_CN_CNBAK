@Echo off
 net use \\172.20.20.55\cn_4201 /u:test1 password
 set DBServer=172.20.20.55\sql2008
 set User=sa
 set Password=password
 set sqlstore=E:\CN_4201\SQLServer2008
 set sqlbak=E:\CN_4201\SQLServer2008\BAK
