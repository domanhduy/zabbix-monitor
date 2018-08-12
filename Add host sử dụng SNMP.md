## 1. Config SNMP trên server zabbix Centos ##

* Cài đặt

		yum install snmp snmp-mibs-downloader
		
		or
		
		yum -y install net-snmp net-snmp-utils 

* Chỉnh sửa config

		mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.bk

		vi etc/snmp/snmpd.conf

Thêm vào các dòng

		rocommunity  public
		syslocation  "NHA"
		syscontact  demo@localhost

![](https://i.imgur.com/BBtbQ1n.png)

rocommunity là thông số quan trọng như là một cái key để liên lạc giữa cliet và server. Chuỗi SNMP community giống như passowrd dùng để thiết lập mối quan hệ giữa server monitor và agent, do đó chúng ta cần khai báo chuỗi SNMP community để monitor có thể truy vấn thông tin từ switch.


* Allow port UDP service SNMP

		firewall-cmd --permanent --add-port=161/udp
			
		firewall-cmd --reload

* Restart service

		systemctl enable snmpd && systemctl start snmpd

* Test 

		snmpwalk -v 1 -c public -O e 127.0.0.1

![](https://i.imgur.com/JeI5Q6A.png)



# 2. Demo add switch  #


Add switch 3750 để zabbix monitor

## 2.1. Cấu hình phía server Switch ##

* Một số lệnh cơ bản

– Cấu hình switch Cisco

· Thiết lập chuỗi SNMP community

· Thiết lập contact và location cho switch Cisco.

· Cấu hình traps cho switch Cisco.

– Cấu hình Zabbix Server

· Theo dõi hoạt động của các interface trên switch.

· Theo dõi CPU, RAM trên switch.

· Tạo cảnh báo nếu CPU của switch bị quá tải trong vòng 5 phút.

· Tạo cảnh báo nếu interface của switch bị down.

· Tạo cảnh báo nếu switch bị down.

* **Lệnh**

no snmp-server: Vô hiệu hóa SNMP.

show snmp: Xem tình trạng của snmp.

snmp-server community: Định nghĩa chuỗi community.

snmp-server contact: Thiết lập chuỗi system contact.

snmp-server enable traps snmp: Bật chức năng traps snmp.

snmp-server host: Cấu hình host sẽ nhận traps.

snmp-server location: Thiết lập chuỗi system location.



* **Cấu hình**

Telnet và vào mode config của switch

		enable
		
		configure terminal 

![](https://i.imgur.com/rgdOIr5.png)

Kiểm tra trạng thái của snmp agent

		show snmp
Vấn ở trong mode config cấu hình một số thông số

– Community

		snmp-server community chuoi_community ro

– Thiết lập contact và location cho switch Cisco: Contact cho biết thông tin liên hệ với người quản lý switch và location cho biết switch ở vị trí nào trong mạng. Để thiết lập contact và location cho switch ta dùng lệnh sau.


		snmp-server contact "Name"

		snmp-server location “Address”

– Cấu hình switch gởi trap đến Zabbix Server (dùng snmpv2): Để cho phép switch gởi traps khi có sự cố cho Zabbix Server chúng ta dùng câu lệnh sau.

		snmp-server enable traps snmp

– Cấu hình host sẽ được gởi trap đến – đó chính là Zabbix Server. Trap mặc định sẽ được gởi thông qua UDP port 162

		snmp-server host ip_zabbix_server version 2c community udp-port 162

– Kiểm tra kết nối đến Zabbix Server

		ping ip_zabbix_server

- Kiểm tra snmp agent trên switch

![](https://i.imgur.com/5jW5TGj.png)

## 2.2. Add host và cấu hình trên web interface zabbix ##

- Add host 

Configuration -> Host -> Create host

![](https://i.imgur.com/0OLCjgU.png)


- Lựa chọn template Templates SNMP Device  

	![](https://i.imgur.com/wC1SsKj.png)


- Macros

	{$SNMP_COMMUNITY} => chuoi_community

chuoi_community đã cấu hình bên switch

- Add host thành công và thu thập data từ switch

![](https://i.imgur.com/RNQ5w9K.png)

![](https://i.imgur.com/DQbT7a2.png)

# 3. Demo add windows 10 qua giao thức SNMP  #

Ngoài sử dụng zabbix agent để kết nối giữa OS Windows với zabbix server thì có thể dùng cách dùng service SNMP để zabbix server thu thập data.


## 3.1. Thao tác trên host windows 10 ##

- Bật tính năng SNMP

Search "Windows Features"

![](https://i.imgur.com/f31ycyH.png)

Mặc định windows off tính năng này, phải bật nên và reboot lại host


- Config services SNMP

	cmd -> services.msc -> SNMP Service
	
- Tìm tới SNMP service -> Chuột phải -> Propeties

![](https://i.imgur.com/ZkV4DOW.png)

- Tab Agent cấu hình contact, location

	![](https://i.imgur.com/9sMq8gu.png)

- Tab Traps: Cấu hình community và IP server Traps zabbix


	![](https://i.imgur.com/wSqtUUQ.png)

- Tab security cấu hình 

![](https://i.imgur.com/9lvQmy2.png)

- Restart serice SNMP service

![](https://i.imgur.com/fyXRoeb.png)

## 3.2. Thao tác trên web interface zabbix ##

- Add host 

Configuration -> Host -> Create host

![](https://i.imgur.com/0OLCjgU.png)


- Lựa chọn template windows

![](https://i.imgur.com/OYJH5pq.png)

- Macros

	{$SNMP_COMMUNITY} => chuoi_community

chuoi_community đã cấu hình bên server

- Add host thành công và thu thập data từ client

![](https://i.imgur.com/ptXB7T5.png)

![](https://i.imgur.com/PxSOOQA.png)

# 4. Demo add host VMware  #

Zabbix hỗ trợ monitor các thông tin về host VMware ESXi thông qua SNMP

## 4.1. Thao tác trên vmware ESXI ##

* SSH vào host VMware ESXi , bật service SNMP và set một số thông số cơ bản

+ Hiển thị thông tin về SNMP của VMware ESXi

		esxcli system snmp get

![Imgur](https://i.imgur.com/tUv0g2b.png)

+ Thiết lập enable, location, contact


		esxcli system snmp set --enable yes

![Imgur](https://i.imgur.com/rIN42UJ.png)

		esxcli system snmp set --syscontact DoDuy
		esxcli system snmp set --syscontact T4
		esxcli system snmp set --communities public

![Imgur](https://i.imgur.com/XQXB14O.png)

## 3.2. Bật service SNMP server trên VMWare ESXi ##

- Truy cập vào vSphere client

![Imgur](https://i.imgur.com/5gzvrCu.png)

## 3.3. Thao tác trên test trên server Zabbix ##

SSH vào server zabbix

		snmpwalk -v 1 -c public -O e 172.16.3.145

![Imgur](https://i.imgur.com/RHAPfGO.png)

## 3.4. Thao tác trên web interface Zabbix ##

- Add host 

Configuration -> Host -> Create host

![Imgur](https://i.imgur.com/8XJCjJ6.png)

Group: Discovered host

- Lựa chọn template Template Virt VMware

![Imgur](https://i.imgur.com/LIKsfBe.png)

- Macros

{$PASSWORD} => username

{$URL} => https://ip_server_vmwar/sdk

{$USERNAME} => password

- Add host thành công và thu thập data từ host VMware ESXi

Đợi một lúc để zabbix server cập nhật trạng thái zabbix server sẽ Discover ra các VM có trong host Vmware ESXi

![Imgur](https://i.imgur.com/x3ahVXg.png)



