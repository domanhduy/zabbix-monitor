# Thao tác cấu hình gửi Zabbix alert qua Telegram #

**1. Tạo bot telegram**

- Yêu cầu bạn phải cài đặt ứng dụng telegram và tạo tài khoản để sử dụng

https://telegram.me/BotFather

Truy cập vào link ở trên telegram sẽ yêu cầu bạn mở app telegram và vào channel Botfarther, ở đó có thể tạo bot cho riêng mình.

![](https://i.imgur.com/QuwsJhD.png)

- Thao tác tạo bot, đặt tên và channel

		/newbot
		/Namebot
		/Namebot

Sau đó telegram sẽ trả về cho bạn một chuỗi token API, phải lưu lại chuỗi token đó.


![](https://i.imgur.com/BbYt28o.png)

- Lấy CHAT_ID

https://api.telegram.org/bot${TOKEN}/getUpdates

Với ${TOKEN} chính là cả chuỗi token API mà khi tạo bot telegram trả về ở trên.

$ curl "https://api.telegram.org/bot${TOKEN}/getUpdates"

![](https://i.imgur.com/5Vxbhaf.png)

+ Kiểm tra sự hoạt động của bot

Chát trên app ở kênh của mình vừa tạo và F5 trình duyệt sẽ thấy thông tin vừa chat, sẽ lấy đk chat ID

![](https://i.imgur.com/tiwXcTk.png)

![](https://i.imgur.com/Kujvclo.png)

Như vậy là bot đã hoạt động và bạn lưu giữu lấy token API và chat ID.

**2. Cấu hình trên Web Zabbix**

Administrator -> Media types -> Update

![](https://i.imgur.com/H2mbT1B.png)

Name: telegram (Tên có thể tùy đặt)

Type: Script

Script name: Tên của script có trong thư mục alert script của server zabbix

Script parameter:

{ALERT.SENDTO}

{ALERT.SUBJECT}

{ALERT.SUBJECT}

* Set user có quyền thực thi alert qua telegram
* Administrator -> User -> Admin -> Media -> Add

(Cho phép user thực hiện gửi alert qua kệnh tetegram)

![](https://i.imgur.com/rn7hIWT.png)

Type: Chính là type mà đã tạo ở trên

Sento: chatID TokenAPI (phải điền đúng cú pháp mới gửi aler thành công).

Use of serverity: Các mức cảnh bảo

Enable: Tích vào

->Update

* Tạo action để khi action xảy ra sẽ có alert qua email 

Configuration -> Action -> Create action

Name: Tên của action muốn tạo

Tab: Conditions là điều kiện để action xảy ra

![](https://i.imgur.com/4NFYkxp.png)

Tab: Operations

Cấu hình những thông số trong quá trình gửi email. Những thứ cần cấu hình:

+Operation type: Send message

+Sento User: Admin

+ Send only to User: Lựa chọn kênh đẩy alert ra.

![](https://i.imgur.com/CC6gA50.png)

=> Hoàn tất quá trình cấu hình trên giao diện web

* Test gửi alert qua telegram khi action được thực hiện

![](https://i.imgur.com/kwSSEnI.png)

![](https://i.imgur.com/buJ453U.png)


