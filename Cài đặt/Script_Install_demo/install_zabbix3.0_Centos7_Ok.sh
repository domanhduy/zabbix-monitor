#!/bin/bash
#duydm
#Install zabbix 3.0 Centos7

#define var
ip a
ls /etc/sysconfig/network-scripts/
echo "Nhap name interface chua ip Server"
read ifcfg

ipserver="$(cat /etc/sysconfig/network-scripts/ifcfg-ens160 | grep IPADDR | cut -d '"' -f 2)"
#---------------------------
#Download repo zabbix và unpackage
#---------------------------

yum install epel-release
rpm -ivh http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm

yum -y install zabbix-server-mysql zabbix-web-mysql mysql mariadb-server httpd php

#---------------------------
# Create Db
#---------------------------

systemctl start mariadb
systemctl enable mariadb

mysql_secure_installation

userMysql="root"
passMysql="0435626533a@"
portMysql="3306"
hostMysql="localhost"
nameDbZabbix="zabbix_db"
userDbZabbix="zabbix_user"
passDbZabbix="0435626533a@"

cat << EOF |mysql -u$userMysql -p$passMysql
DROP DATABASE IF EXISTS zabbix;
create database zabbix_db character set utf8 collate utf8_bin;
grant all privileges on zabbix_db.* to zabbix_user@localhost identified by '0435626533a@';
flush privileges;
exit

EOF

echo "Create DB Zabbix OK"
#---------------------------
#Import database zabbix
#---------------------------
cd /usr/share/doc/zabbix-server-mysql-3.0.19
gunzip create.sql.gz
mysql -u root -p zabbix_db < create.sql

#---------------------------
#Config DBc
# edit vi /etc/zabbix/zabbix_server.conf
#---------------------------

sed -i 's/# DBHost=localhost/DBHost=localhost/g' /etc/zabbix/zabbix_server.conf
sed -i "s/DBName=zabbix/DBName=$nameDbZabbix/g" /etc/zabbix/zabbix_server.conf
sed -i "s/DBUser=zabbix/DBUser=$userDbZabbix/g" /etc/zabbix/zabbix_server.conf
sed -i "s/# DBPassword=/DBPassword=$passDbZabbix/g" /etc/zabbix/zabbix_server.conf

#---------------------------
#Configure PHP Setting
#---------------------------
sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 600/g' /etc/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php.ini
echo "date.timezone = Asia/Ho_Chi_Minh" >> /etc/php.ini


#---------------------------
#Allow the ports in the Firewall
#---------------------------
 
firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --permanent --add-port=10051/tcp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --reload 
systemctl restart firewalld

#---------------------------
#Restart service
#---------------------------

systemctl start zabbix-server
systemctl enable zabbix-server
systemctl start httpd
systemctl enable httpd

systemctl restart zabbix-server
systemctl restart httpd

echo "Login with http://$ipserver/zabbix"
 

