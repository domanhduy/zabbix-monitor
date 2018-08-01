Sử dụng giao thức SSH để xác thực giữa các server

* Tạo RSA Key Pair

    ssh-keygen -t rsa

Bạn có thể chỉ định thư mục lưu key hoặc enter (empty) thì key sẽ lưu vào thư mục mặc định.

![](https://i.imgur.com/a6AiveA.png)


The public key lưu ở /root/.ssh/id_rsa.pub

The private key (identification)lưu ở /root.ssh/id_rsa


* Copy public key gửi tới máy client

    ssh-copy-id user@ip_server

![](https://i.imgur.com/aMB0Nmy.png)

 Lần đầu copy key sang sẽ yêu cầu nhập password. Bạn tiến hành nhập password và các lần sau không yêu ci nhập pass nữa.

    ssh user@ip_server

 ![Imgur](https://i.imgur.com/5KvO1Hd.png)

 Lần này bạn có thể truy nhập thẳng vào server mà không cần nhập pass nữa.



