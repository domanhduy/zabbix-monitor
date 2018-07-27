# Thao tác cấu hình gửi Zabbix alert qua Slack #

* **Đẩy script lên thư mục chứa script Zabbix**

+Lấy đường dẫn chứa script

	grep AlertScriptsPath /etc/zabbix/zabbix_server.conf

![](https://i.imgur.com/SCqi1pG.png)

+Đẩy scritp bằng file tranfer

![](https://i.imgur.com/G7rDhmB.png)

+ **Yêu cầu phải tạo vào có webhook slack**

	https://my.slack.com/services/new/incoming-webhook

![](https://i.imgur.com/uXuEyUa.png)

* Chỉnh sửa config trong script

Chỉnh sửa địa chỉ webhook slack chính là địa chỉ webhook đã tạo ở trên

![](https://i.imgur.com/HPXWXsc.png)

* Test xem slack đã nhận được thông báo bằng cách dùng lệnh

	[root@localhost alertscripts]# bash slack.sh

![](https://i.imgur.com/50AAcTl.png)

**Thao tác trên web interface zabbix**

* Thêm media types cho zabbix

Administrator -> Media types -> Update

![](https://i.imgur.com/DMwFgDT.png)

Name: Slack (Tên có thể tùy đặt)

Type: Script

Script name: Tên của script có trong thư mục alert script của server zabbix

Script parameter:

{ALERT.SENDTO}

{ALERT.SUBJECT}

{ALERT.SUBJECT}

* Set user có quyền thực thi alert qua Slack

Administrator -> User -> Admin -> Media -> Add

![](https://i.imgur.com/pUvKeBt.png)

Type: Chính là type mà đã tạo ở trên

Sento: Địa chỉ của channel slack tương ứng với webhook slack

Use of serverity: Các mức cảnh bảo

Enable: Tích vào

->Update 

* Tạo action để khi action xảy ra sẽ có alert qua email

![](https://i.imgur.com/U0JUjEY.png)

Name: Tên của action muốn tạo

Tab: Conditions là điều kiện để action xảy ra


Tab: Operations

![](https://i.imgur.com/ARU3Fnk.png)

Cấu hình những thông số trong quá trình gửi email. Những thứ cần cấu hình:

+Operation type: Send message

+Sento User: Admin

+Send only to User: Lựa chọn kênh đẩy alert ra.

=> Hoàn tất quá trình cấu hình trên giao diện web

* **Test gửi alert qua slack khi action được thực hiện**

![](https://i.imgur.com/fG7I75q.png)


