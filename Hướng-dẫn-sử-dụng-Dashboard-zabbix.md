# Hướng dẫn thao tác trên Dashboard zabbix #
Đây là giao diện tổng quan khi cài đặt zabbix thành công. Gồm nhiều mục lớn như Monitoring, Inventory, Reports, Configuration, Administrator. Trong các tab lớn sẽ bao gồm nhiều task thành phần nhỏ hơn.

![](https://i.imgur.com/XVNxgwV.png)


## 1. Tab Monitoring ##


![](https://i.imgur.com/c6xpY6q.png)

**1.1. Dashboard**

**Dashboard**: Là giao diện hiển thị các dashboard trực quan để người quản trị nhìn trực tiếp, người quản trị có thể tạo ra rất nhiều các dashboard khác nhau, nhưng tại một tab screen chỉ có thể xem được 1 dashboard bất kỳ nào đó.

Từ Dashboard có thể nhanh chống liên kết đến các thành phần như Graphs, Screens, Map bằng cách thêm các thành phần mong muốn vào mục Favourite graphs, Favourite Screen và Favourite map.
![](https://i.imgur.com/1ZM0u8p.png)

Gồm nhiều phần hiển thị nhỏ hơn:

+ Status of Zabbix

Bảng này hiển thị trạng thái của zabbix server, số lượng các host, trigger, item, số người đang đăng nhập và trạng thái của các thông số trên ở 2 cột value và Details

![](https://i.imgur.com/3QBTvi4.png)

+ System status: Hiển thị mức độ cảnh báo của từ host trong từng group

![](https://i.imgur.com/j2GCjiM.png)

+ Problems: Tất cả các vấn đề xảy ra với các host trong các group thống kê theo thời gian.

![](https://i.imgur.com/GzAlWl2.png)

+ Các bảng để hiển thị sẵn graphs, screens, maps

![](https://i.imgur.com/EFykCyg.png)

Có thể tùy chỉnh add thêm những gì muốn hiển thị theo ý muốn tương ứng với từng mục.

+ Đối với mỗi bảng có thể tùy chỉnh thờ gian interval để update lại data

Click vào dấu ... nhỏ để cấu hình như ở dưới

![](https://i.imgur.com/kj9wCpK.png)

**1.2. Problems**

+Problems: Hiển thị các vấn đề đối với từng device mà zabbix server thu thập dữ liệu về. Hỗ trợ cơ chế lọc theo ý người quản trị.

![](https://i.imgur.com/ZJfmqjk.png)

+ Có thể lọc theo các tiêu chí sau và có thể export ra file csv để lưu trữ lại.

![](https://i.imgur.com/3LHKazf.png)

Show: Recent problems (Hiển thị vấn đề hiện tại đang gặp phải), Problems (Hiển thị các vấn đề đã gặp phải), History (Lịch sử các vấn đề đã gặp phải).

Host group, Host, Application, Trigger, Problem, Host inventory, Tags, Show hosts in maintenance... là các lựa chọn để lọc thông tin, có thể lọc theo một tiêu chí hoặc kết hợp nhiều tiêu chí.
 
**1.3. Overview**

+Overview: Là sự tổng hợp thông tin về data zabbix zerver thu thập được, có thể lọc them group -> host -> Kiểu data.

![](https://i.imgur.com/e7VAhYK.png)

**1.4. Latest data**

+Latest data: Dữ liệu mới nhất mà zabbix server thu thập được.

![](https://i.imgur.com/WqVd6Tu.png)

**1.5. Triggers**
+Triggers: Là một điều kiện khi thỏa mãn điều kiện của Triggers mà người lập trình đặt ra thì sẽ thực hiện một hành động nào đó tiếp theo.

![](https://i.imgur.com/nNu32ee.png)

**1.6. Graphs**

+Graphs:  Là các thông tin dữ liệu được biểu diễn dưới dạng biểu đồ theo thời gian thực ví dụ như trafiic qua interface của thiết bị, thông tin về tình trạng CPU, RAM, ổ cứng… Các thông tin này được định nghĩa trong các templates.

Hỗ trợ lọc theo group -> host -> Dạng graph

Tại một thời điểm chỉu xem được 1 thông số dạng graph của 1 server. Cung cấp cái nhìn đơn lẻ về một đối tượng nhất định cần giám sát

![](https://i.imgur.com/j1XMqL7.png)

**1.7. Screen**

+Screen: Là tập hợp các thông tin như Graphs, maps,data overview… vào chung một màn hình giám sát. Giúp người quản trị có thể lựa chọn các thông tin cần thiết hiển thị, giúp có cái nhìn tổng quát những thông tin mà người quản trọ mong muốn.

![](https://i.imgur.com/NiFg7vM.png)

**1.8. Maps**

+Maps: Là thành phân cung cấp khả năng giám sát hệ thống dưới hình thức mô hình mạng. Giúp người quản trị có cái nhìn tổng quan về hệ thống sống mạng dưới dạng sơ đồ, trong trường hợp có sự cố sẽ giúp người quản trị đánh giá tầm ảnh hưởng của thiết bị gặp sự cố và đưa ra giải pháp phù hợp.

![](https://i.imgur.com/1fwhYj7.png)

**1.9. Discovery**

+Discovery: Tính năng cho phép zabbix server tự động tìm kiếm các thiết bị được cài đặt zabbix agent đã cấu hình kết nối về zabbix server trong cùng mạng với zabbix server.

![](https://i.imgur.com/fz3rDLa.png)



## 2. Tab Configuration ##

**2.1.Host group** 

+ Host group: Tập hợp lại các host có chung một mục đích sử dụng hoặc người quản trị tâp hợp lại để phục vụ một mục đích quản lý chung.

![](https://i.imgur.com/FfNtPUx.png)

**2.2. Templates**

+ Templates: Đây là tập hợp các thực thể có thể áp dụng cho các Host, một Template sẽ chứa trong nó các tập lệnh để truy vấn lấy dữ liệu, hiển thị thông tin dữ liệu lấy được, thông tin tình trạng thiết bị, hiển thị và thông báo lỗi…

Trong mỗi Template, các tệp lệnh được chia thành: items, triggers, graphs, applications, screens (có từ Zabbix 2.0),low-level discovery rules (có từ Zabbix 2.0), web scenarios (có từ Zabbix 2.2). Tùy theo giám sát thiết bị, dịch vụ, ứng dụng… nào thì các thành phần này được thiết lập khác nhau.

Có thể import template tự viết vào.

![](https://i.imgur.com/NGyKNcG.png)

**2.3. Host**

+ Host: Là một máy tính, server, vps, chạy các hệ điều hành khác nhau hoặc một thực thể trong hệ thống mạng như là máy in, máy chấm công, máy photo, máy camera có hỗ trợ các giao thức mà monitor zabbix cung cấp.

![](https://i.imgur.com/TW736G4.png)

**2.4. Maintance**

+ Maintance: Có thể xác định thời gian bảo trì cho máy chủ và group trong Zabbix. Có hai loại Maintance - với thu thập dữ liệu và không thu thập dữ liệu.

Ví dụ server của bạn off trong khoảng thời gian này để nâng cấp sửa chữa, thì maintance sẽ được lựa chọn cấu hình để không thu thập data trong khoảng thời gian đó. 

![](https://i.imgur.com/Zkos0c5.png)

**2.5. Action**

+ Action: Nơi cấu hình, lựa chọn các kiểu thông báo khi có sự kiện xảy ra bởi cấu hình trigger. Người dùng phải tự định nghĩa các action theo mục đích.

![](https://i.imgur.com/vBhVqY3.png)

**2.6. Event correlation**

Cho phép cấu hình tương quan giữa các sự kiến với độ chính xác vào và tùy biến linh hoạt.


**2.7. Discovery**

Thiết lập range IP, nếu trong range có có thiết bị nào mà cài đặt các giao thức mà Zabbix server hỗ trợ thì sẽ tự động thu thập data về

![](https://i.imgur.com/5G3ZIEt.png)

## 3. Tab Administrator ##

Chức năng của của tab Administrator là để cấu hình chung cho zabbix đối với user có quyền Admin

![](https://i.imgur.com/oJJFz7K.png)

**3.1. General**
Mục này cho phép người quản trị cấu hình tùy chỉnh giao diện cho Zabbix Webinterface. 

![](https://i.imgur.com/XgyCO6G.png)

Có thể tùy chỉnh rất nhiều giao diện như :

+ GUI: Cung cấp một số tùy chỉnh mặc định liên quan đến giao diện người dùng.

![](https://i.imgur.com/5bslOhm.png)

Default theme: Chủ đề mặc định của giao diện. Thường là màu xanh da trời.

Dropdown first entry: Chọn nó là mục đầu tiên trong Drop down.

Search/Filter elements limit: Số lượng tối đa hiển thị các hàng trong tìm kiếm và lọc.

Max count of elements to show inside table cell: Giới hạn hiển thị trong bảng.

Enable event acknowledges: Cho phép các event trong Zabbix kích hoạt.

Show events not older than (in days): Cho phép hiển thị trạng thái Trigger bao nhiêu ngày.

Max count of events per trigger to show: Số event được kích hoạt tối đa trong màn hình trạng thái.

Show warning if Zabbix server is down: Cho phép hiển thị một thông điệp cảnh báo khi không kết nối được Zabbix Server.


+ HouseKeeping: quy định các thời gian định kì được thực hiện bởi Zabbix . Quá trình xóa thông tin hết hạn và thông tin được xóa bởi người dùng .Có thể tùy chỉnh các dữ liệu được lưu tối đa trong bao lâu trên Zabbix. Gồm các phần có thể cấu hình như Event and alerts, Services, Audit, User sessions, History, Trends.

![](https://i.imgur.com/ijmFItc.png)

Enable internal housekeeping: Lựa chọn bật hoặc tính time để xóa bỏ thông tin.


Trigger data storage period: Khoảng thời gian dọn dẹp các thông in về việc lưu trữ data trigger

Internal data storage period: Khoảng thời gian dọn dẹp Internal data storage.

Network discovery data storage period: Khoảng thời gian dọn dẹp discovery data storage.

+ Images: Chứa tất cả các hình ảnh, icon, background được hiển thị trong Zabbix.

![](https://i.imgur.com/RYBR5vW.png)

+ Icon mapping: Phần này cho phép tạo biểu tượng bản đồ của một host với các biểu tượng nhất định. Các thông tin trong các tùy chọn đều phục vụ cho việc tạo bản đồ.

![](https://i.imgur.com/KbM2VOh.png)

Name: Tên icon map (duy nhất).

Mappings: Danh sách các ánh xạ mà Icon map tham chiếu đến.

Inventory field: List các danh sách thiết bị tồn tại.

Expression: Mô tả biểu thức chính quy.

Icon: Icon được dùng nếu biểu thức chính quy lỗi.

Default: icon mặc định được dùng.

+ Regular expressions: Tạo và quy ước các biểu thức chính quy.

![](https://i.imgur.com/zfZPL3R.png)

+ Macros: Tạo các đoạn macro tương ứng với giá trị.

![](https://i.imgur.com/DuklGSY.png)

+ Value mapping: Tạo các giá trị tương ức với các mức.

![](https://i.imgur.com/PlLFX8p.png)

+ Working time: Tham số toàn hệ thống xác định thời gian làm việc.

![](https://i.imgur.com/6W7D40P.png)

+ Trigger severities: Cấu hình màu hiển thị đối với các mức cảu trigger.

![](https://i.imgur.com/Pvikqyv.png)

+ Trigger displaying options: Mầu sắc, hiệu ứng iển thị khi có event.

![](https://i.imgur.com/2xmHeCW.png)


+ Other configuration parameters



**3.2. Proxies**

Cho phép cấu hình các Proxy trên giao diện Zabbix

![](https://i.imgur.com/mLXQkfA.png)

Name: Tên của Proxy.

Mode: Chế độc của Proxy (active hoặc passive).

Encryption: Mã hóa kết nối từ Zabbix Server đến Proxy.

Last seen (age): Thời gian tại thời điểm kết nối cuối cùng với Proxy.

Host count: Số Host mà Proxy quản lý.

Item count: Số lượng Item mà Proxy sử dụng.

Required performance (vps): Hiệu suất Proxy.

Host: Danh sách các host mà proxy quản lý.

**3.3. Authentication**
Phương pháp xác thực người dùng Zabbix : Thẩm định nội bộ, LDAP và HTTP

![](https://i.imgur.com/Wl8GQxb.png)

**3.4. User groups**

Quản lý các nhóm trong Zabbix

![](https://i.imgur.com/O1GldkN.png)

**3.5. Users**

Tùy chỉnh các tài khoản user cho zabbix

![](https://i.imgur.com/jv5RwwE.png)

Có thể tạo thêm các user khác với việc phân quyền tương ứng.

**3.6. Media types**

Các kênh alert

![](https://i.imgur.com/0S7JHE9.png)

**3.7. Scripts**

**3.8. Queue**

Thông tin về hàng đợi trong quá trình cập nhật dữ liệu về từ các nguồn agent.

![](https://i.imgur.com/D5XTyzR.png)



