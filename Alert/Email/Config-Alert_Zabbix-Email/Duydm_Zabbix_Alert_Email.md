# Thao tác cấu hình gửi Zabbix alert qua Email #

**1. Cài đặt cấu hình edit script alert smtp**

- Cài đặt python: Do script được viết bằng python nên phải cài đặt python thì script mới chạy được.

		apt-get install python2.7
	   	apt-get install python-pip

- Check version python

		 python --version
		 pip --version

![](https://i.imgur.com/VnSQtX8.png)

* Check thư mục chứ script alert

		cat /etc/zabbix/zabbix_server.conf | grep alert

![](https://i.imgur.com/gJR98vx.png)

* Load script (có thể dùng nhiều cách để lấy file script về).

		cd /usr/lib/zabbix/alertscripts

		wget https://gist.githubusercontent.com/superdaigo/3754055/raw/e28b4b65110b790e4c3e4891ea36b39cd8fcf8e0/zabbix-alert-smtp.sh

* Edit config trong script

		cd /usr/lib/zabbix/alertscripts

		vi zabbix-alert-smtp.sh

Nhập email và password để gửi email cảnh báo.

		# Mail Account
		MAIL_ACCOUNT = 'your.account@gmail.com'
		MAIL_PASSWORD = 'your mail password'

* Định dạng lại script cho đúng chuẩn script

		apt-get install dos2unix
		dos2unix zabbix-alert-smtp.sh

* Test gửi email 

		./zabbix-alert-smtp.sh duydm@localhost "Test" "Alert Zabbix"

![](https://i.imgur.com/FO1uTrq.png)


**2. Cấu hình trên Web Zabbix**

* **Thêm media types cho zabbix**


Administrator -> Media types -> Update

![](https://i.imgur.com/pFrW9UK.png)


Name: Gmail (Tên có thể tùy đặt)

Type: Script

Script name: Tên của script có trong thư mục alert script của server zabbix

Script parameter:

{ALERT.SENDTO}

{ALERT.SUBJECT}

{ALERT.SUBJECT}

* **Set user có quyền thực thi alert qua gmail**

Administrator -> User -> Admin -> Media -> Add

(Cho phép user thực hiện gửi alert qua kệnh email)

![](https://i.imgur.com/idNYXre.png)

Type: Chính là type mà đã tạo ở trên

Sento: Địa chỉ emal sẽ nhận được alert

Use of serverity: Các mức cảnh bảo

Enable: Tích vào

->Update 

* **Tạo action để khi action xảy ra sẽ có alert qua email**

Configuration -> Action -> Create action

![](https://i.imgur.com/5soREq4.png)

Name: Tên của action muốn tạo

Tab: Conditions là điều kiện để action xảy ra

![](https://i.imgur.com/vOoHqFD.png)

Tab: Operations

Cấu hình những thông số trong quá trình gửi email. Những thứ cần cấu hình:

+Operation type: Send message

+Sento User: Admin

+ Send only to User: Lựa chọn kênh đẩy alert ra.

![](https://i.imgur.com/dFABRu1.png)

=> Hoàn tất quá trình cấu hình trên giao diện web

* Test gửi alert qua email khi action được thực hiện

![](https://i.imgur.com/m7F0dco.png)

![](https://i.imgur.com/6OniXXq.png)