#!/bin/bash
#duydm
#Install zabbix Ubuntu 16.04

#define var
ipserver="$(cat /etc/network/interfaces | grep address | cut -d ' ' -f 2)"
#---------------------------
#Download repo zabbix và unpackage
#---------------------------
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
wget http://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+xenial_all.deb
dpkg -i zabbix-release_3.4-1+xenial_all.deb

#Update package + Install zabbix server and other package

apt-get update -y
apt-get install zabbix-server-mysql zabbix-frontend-php zabbix-agent zabbix-get zabbix-sender snmp snmpd snmp-mibs-downloader php7.0-bcmath php7.0-xml php7.0-mbstring -y

#Edit time zone zabbix server
#/etc/zabbix/apache.conf

sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Asia\/Ho_Chi_Minh/g' /etc/zabbix/apache.conf
systemctl reload apache2
echo "Create DB zabbix mysql"

#---------------------------
# Create Db
#---------------------------

userMysql="root"
passMysql="0435626533a@"
portMysql="3306"
hostMysql="localhost"
nameDbZabbix="zabbixdb"
userDbZabbix="zabbixuser"
passDbZabbix="0435626533a@"

cat << EOF |mysql -u$userMysql -p$passMysql
DROP DATABASE IF EXISTS zabbix;
create database zabbixdb character set utf8 collate utf8_bin;
grant all privileges on zabbixdb.* to zabbixuser@localhost identified by '$passMysql';
flush privileges;
exit

EOF

echo "Create DB Zabbix OK"

#---------------------------
#Import database zabbix
#---------------------------

cd /usr/share/doc/zabbix-server-mysql/
zcat create.sql.gz | mysql -u$userMysql -p$passMysql zabbixdb

#---------------------------
#Config DBc
# edit vi /etc/zabbix/zabbix_server.conf
#---------------------------

# fileZabbixConfig = /etc/zabbix/zabbix_server.conf

sed -i 's/# DBHost=localhost/DBHost=localhost/g' /etc/zabbix/zabbix_server.conf
sed -i "s/DBName=zabbix/DBName=$nameDbZabbix/g" /etc/zabbix/zabbix_server.conf
sed -i "s/DBUser=zabbix/DBUser=$userDbZabbix/g" /etc/zabbix/zabbix_server.conf
sed -i "s/# DBPassword=/DBPassword=$passDbZabbix/g" /etc/zabbix/zabbix_server.conf


#---------------------------
#Restart service
#---------------------------

systemctl enable zabbix-server 
systemctl enable zabbix-agent 

service zabbix-agent start
service zabbix-server start

service apache2 restart

echo "Login with http://$ipserver/zabbix"



