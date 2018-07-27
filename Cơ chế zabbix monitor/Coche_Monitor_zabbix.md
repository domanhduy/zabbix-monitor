# Các cơ chế zabbix dùng để giám sát #

## 1. Zabbix agent ##

Một zabbix agent được viết bằng ngôn ngữ C, chạy trên nhiều nền tảng khác nhau như Unix, Linux, Windows và chúng sử dụng để thu thập dữ liệu như CPU, memory, disk, network từ một thiết bị được sử dụng.

Là một tiến trình nhỏ, tài nguyên sử dụng ít: Zabbix agent là một service đơn giản có thể chạy trên một thiết bị có nguồn tài nguyên giới hạn, cấu hình thấp.

Cấu hình monitor ở trên một thành phần tập trung zabbix server, quản lý các agent một cách dễ dàng, sử dụng một file cấu hình duy nhất trên tất cả các server.

- Để thu thập và lấy được data zabbix sử dụng 2 cơ chế phổ biến sau:

   **passive check (polling)**

   **active checks (trapping)**

Zabbix check thông tin trong một khoảng thời gian interval nhất định. Khoảng thời gian interval này có thể được cấu hình trong chế độ passive check (polling).

- **Passive check (polling)**:

Zabbix server (hoặc proxy) yêu cầu lấy giá trị từ zabbix agent

Tiến trình agent nhận thông báo và trả lại giá trị tới zabbix server (hoặc proxy).

Server chủ động hỏi - client thu thập rồi trả lời thỏa mãn yêu cầu của server (agent đóng vai trò bị động, agent quyết định vai trò)

- **Active checks (trapping)**:

Zabbix agent yêu cầu từ Zabbix server (hoặc proxy) danh sách các lisk check (agent chủ động đi hỏi client xem list check cần thu thập data là gì và gửi lại kết quả, clent đóng vai trò chủ động)

Agent gửi kết quả định kỳ về server


**Một số chức năng, thông số agent có thể thu thập được**


- Network	

        Packets/bytes transfered
        Errors/dropped packets
        Collisions

- CPU	

        Load average
        CPU idle/usage
        CPU utilization data per individual process
- Memory

        Free/used memory
        Swap/pagefile utilization
- Disk	

        Space free/used
        Read and write I/O
- Service	

        Process status
        Process memory usage
        Service status (ssh, ntp, ldap, smtp, ftp, http, pop, nntp, imap)
        Windows service status
        DNS resolution
        TCP connectivity
        TCP response time
- File	

        File size/time
        File exists
        Checksum
        MD5 hash
        RegExp search
- Log	

        Text log
        Windows eventlog
- Other	

        System uptime
        System time
        Users connected
        Performance counter (Windows)

## 2. SNMP agent ##

**2.1. Giao thức SNMP**

**- Tổng quan**

SNMP (Simple Network Management Protocol) là một tập hợp các giao thức không chỉ cho phép kiểm tra nhằm đảm bảo các thiết bị mạng như router, switch hay server đang vận hành mà còn vận hành một cách tối ưu, ngoài ra SNMP còn cho phép quản lý các thiết bị mạng từ xa, hệ thống Unix, Linux, Windows...

SNMP dùng để quản lý, nghĩa là có thể theo dõi, có thể lấy thông tin, có thể được thông báo, và có thể tác động để hệ thống hoạt động như ý muốn.

Một số khả năng của phần mềm SNMP:

+Theo dõi tốc độ đường truyền của một router, biết được tổng số byte đã truyền/nhận.

+Lấy thông tin máy chủ đang có bao nhiêu ổ cứng, mỗi ổ cứng còn trống bao nhiêu.

+Tự động nhận cảnh báo khi switch có một port bị down.

+Điều khiển tắt (shutdown) các port trên switch.

SNMP dùng để quản lý mạng, nghĩa là nó được thiết kế để chạy trên nền TCP/IP và quản lý các thiết bị có kết nối mạng TCP/IP. Các thiết bị mạng không nhất thiết phải là máy tính mà có thể là switch, router, firewall, ADSL gateway, và cả một số phần mềm cho phép quản trị bằng SNMP.

**- Thành phần**

Một hệ thống sử dụng SNMP bao gồm 2 thành phần chính:

Manager: Là một máy tính chạy chương trình quản lý mạng. Manager còn đuợc gọi là một NMS (Network Management Station). Nhiệm vụ của một manager là truy vấn các agent và xử lý thông tin nhận đuợc từ agent.

Agent: Là một chương trình chạy trên thiết bị mạng cần được quản lý. Agent có thể là một chương trình riêng biệt  hay được tích hợp vào hệ điều hành. Nhiệm vụ của agent là thông tin cho manager.

![](https://i.imgur.com/ywSTvAK.png)

**Cấu trúc MIB và Object Identifier (Object ID hoặc OID)**

Thông tin cơ sở quản lý (MIB) là một tập hợp các thông tin để quản lý phần tử mạng. Các MIBs gồm các đối tượng quản lý được xác định bởi các định danh tên đối tượng (Object ID hoặc OID).

Mỗi định danh là duy nhất và biểu thị đặc điểm cụ thể của một thiết bị quản lý. Khi được hỏi cho, giá trị trả về của mỗi dạng có thể là khác nhau ví dụ như Text, Number, Counter, vv …

Có hai loại Managed Object hoặc Object ID: Scalar và dạng bảng. Họ có thể dễ hiểu hơn với một ví dụ

Vô hướng: tên nhà cung cấp thiết bị của, kết quả có thể chỉ có một. (Như định nghĩa nói: “Đối tượng vô hướng xác định một trường hợp đối tượng duy nhất”)

Tabular: sử dụng CPU của một bộ xử lý Quad, điều này sẽ cung cấp cho tôi một kết quả cho mỗi CPU riêng biệt, có nghĩa là sẽ có 4 kết quả cho rằng Object ID cụ thể. (Như định nghĩa nói: “đối tượng dạng bảng xác định nhiều trường hợp đối tượng liên quan được nhóm lại với nhau trong các bảng MIB”)

Mỗi ID Object được tổ chức theo thứ bậc trong MIB. Các hệ thống phân cấp MIB có thể được đại diện trong một cấu trúc cây với tên biến cá nhân.
Một ID đối tượng điển hình sẽ có một danh sách các số nguyên rải rác. Ví dụ, các OID trong RFC1213 cho “sysDescr” là .1.3.6.1.2.1.1.1

**- Hoạt động**

SNMP sử dụng UDP (User Datagram Protocol) như là giao thức truyền tải thông tin giữa các manager và agent. Việc sử dụng UDP, thay vì TCP, bởi vì UDP là phương thức truyền mà trong đó hai đầu thông tin không cần thiết lập kết nối trước khi dữ liệu được trao đổi (connectionless), thuộc tính này phù hợp trong điều kiện mạng gặp trục trặc, hư hỏng ...

SNMP có các phương thức quản lý nhất định và các phương thức này đuợc định dạng bởi các gói tin PDU (Protocol Data Unit). Các manager và agent sử dụng PDU để trao đổi với nhau.

![](https://i.imgur.com/hKSf1tg.png)

Bản tin Trap được agent tự động gửi cho manager mỗi khi có sự kiện xảy ra bên trong agent, các sự kiện này không phải là các hoạt động thường xuyên của agent mà là các sự kiện mang tính biến cố

**2.2. SNMP agent check**

Thường sử dụng SNMP monitor cho các thiết bị như printer, switch, router, UPS mà trên các thiết bị này thường được bật SNMP.


Để có thể lấy được thông tin từ client SNMP agent về, server zabbix phải được cấu hình để hỗ trợ giao thức SNMP

SNMP chỉ thực hiện thông qua giao thức UDP


## 3. SSH check ##

SSH check là một phương thức check giống như kiểu agent-less monitoring.

Zabbix có thể thực hiện các lệnh shell trên SSH và ghi lại các kết quả, không yêu cầu có zabbix agent, phù hợp trong việc kiểm tra các server từ xa.

## 4. IPMI agent ##

Service Processor là một vi xử lý nằm trên bo mạch chủ của server, trên card PCI, hoặc trên chassis của blade server, có khả năng thu thập các thông tin vật lý của server (nhiệt, quạt, nguồn điện…), hoạt động độc lập với CPU và hệ điều hành của server.

Service Processor có thể được truy cập thông qua cổng Ethernet dành riêng (out-of-band) hoặc qua cổng Ethernet chia sẻ dữ liệu (sideband).

Service Processor cung cấp khả năng truy cập, điều khiển nguồn từ xa (bật/tắt/khởi động lại), theo dõi các thông tin vật lý: trạng thái/tốc độ quạt, nhiệt độ, vi xử lý, bộ nhớ RAM, card mạng và cho phép truy cập, điều khiển serial từ xa thông qua tính năng Serial over LAN (SoL). Tùy theo từng loại Service Processor, có thể hỗ trợ những tính năng nâng cao như theo dõi điện năng tiêu thụ, remote console, tính năng vKVM (KVM ảo) và Virtual Media.

IPMI (Intelligent Platform Management Interface) là công nghệ xử lý giao tiếp trên Service Processor được phát triển đầu tiên bởi Intel cùng với sự hỗ trợ của các nhà sản xuất khác. Năm 1998, Dell, Hewlett-Packard, Intel, và NEC công bố chuẩn IPMI 1.0. Cho đến nay phiên bản mới nhất là IPMI 2.0 được công bố ngày 14/2/2004.


