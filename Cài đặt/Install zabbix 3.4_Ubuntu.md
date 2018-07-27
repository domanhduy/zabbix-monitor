## Hướng dẫn cài đặt Zabbix-server##

## 1. Chuẩn bị ##

**1.1. Mô hình**

**1.2. IP Planning**

![](https://i.imgur.com/HctgUl3.png)
## 2. Các bước cài đặt ##
* **Download repo zabbix và unpackage**

		wget http://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+xenial_all.deb
		dpkg -i zabbix-release_3.4-1+xenial_all.deb


![](https://i.imgur.com/WlN0rqH.png)


- **Update lại package mới + Cài đặt zabbix server và các gói cài đặt cần thiết: zabbix server, zabbix client, mysql, php...**

		apt-get update -y


![](https://i.imgur.com/L6w3xvV.png)

	apt-get install zabbix-server-mysql zabbix-frontend-php zabbix-agent zabbix-get zabbix-sender snmp snmpd snmp-mibs-downloader php7.0-bcmath php7.0-xml php7.0-mbstring

![](https://i.imgur.com/Y2K8nTO.png)


- **Edit time zone của zabbix server**

Mở file /etc/zabbix/apache.conf chỉnh time zone Việt Nam : Asia/Ho_Chi_Minh

	vi /etc/zabbix/apache.conf

![](https://i.imgur.com/ZVJwjsa.png)


Reload lại service apache

	systemctl reload apache2


- Tạo database và user truy cập databaser


Truy cập vào database

	mysql -u root -p

![](https://i.imgur.com/Jjyr6Tu.png)

Tao dabase với tên là zabbixdb


		MariaDB [(none)]> create database zabbixdb character set utf8 collate utf8_bin;

![](https://i.imgur.com/8hErVqI.png)

Gán quyền và đặt password cho database vừa tạo ở trên

		MariaDB [(none)]> grant all privileges on zabbixdb.* to zabbixuser@localhost identified by '123456a@';

Xác nhận query và thoát


		MariaDB [(none)]> flush privileges;

		MariaDB [(none)]> quit


![](https://i.imgur.com/qC95PgH.png)

Import database ban đầu của zabbix

		cd /usr/share/doc/zabbix-server-mysql/
		zcat create.sql.gz | mysql -u root -p zabbixdb
		Enter password:

Config database


		 vi /etc/zabbix/zabbix_server.conf

Tìm và sửa các thông số

		DBHost=localhost
		DBName=zabbixdb
		DBUser=zabbixuser
		DBPassword=123456a@


![](https://i.imgur.com/3cWTtmy.png)


Restart service zabbix-server, zabbix-agent


		enable zabbix-server 
		systemctl start zabbix-server
		systemctl enable zabbix-agent 
		systemctl start zabbix-agent


- **Truy cập bằng trình duyệt hoàn tất kết nối qua giao diện**

Truy cập đường dẫn: http://172.16.3.199/zabbix


![](https://i.imgur.com/pUdcJcx.png)


Check các thành phần bắt buộc có để cài đặt zabbix server thành công



![](https://i.imgur.com/YgUWXzv.png)

 Nhập các thông tin kết nối đền database đã tạo ở trên

![](https://i.imgur.com/u85xCY9.png)


Nhập name hiển thị đại diện cho zabbix server


![](https://i.imgur.com/K51yYj0.png)

Check lại thông tin đã nhập

![](https://i.imgur.com/nO8TVoU.png)

Cấu hình thành công


![](https://i.imgur.com/9bAsZwb.png)

Login với tài khoản mặc định Admin/zabbix

![](https://i.imgur.com/7SMZgbs.png)

- **Cài đặt thành công zabbix**


![](https://i.imgur.com/gKSqonc.png)

