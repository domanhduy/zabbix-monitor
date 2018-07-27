#Phân tích metric RAM, DISK, CPU#

![](https://i.imgur.com/hqLYTcb.png)

## 1. RAM ##
**1.2. Cấu trúc RAM Linux**

Trong linux, memory được tổ chức thành các page chừng 4KB, tùy vào dòng CPU, hệ điều hành mà con số này có thể thay đổi, có thể lên đến 8KB hay 16KB một page.

Linux có xu hướng caching nhiều thứ để tăng tốc, vì đó mà RAM thường xuyên được giải phóng, lưu tạm vào đĩa và sử dụng nếu cần.

Tuy nhiên, thông số MemFree trả về không phải là lượng bộ nhớ hệ thống còn trống.

Bởi vì Total memory ở Linux được tính bằng Active memory + Inactive memory (không tính Swap). Vấn đề ở chỗ Inactive memory, là vùng nhớ khi ta run 1 process và tắt đi, system sẽ cache lại vùng nhớ này để khi gọi lại process này lần nữa, nó sẽ sử dụng vùng nhớ inactive này ngay lập tức thay vì phải cấp phát lại. Nên khi ta mở càng nhiều process, sau đó tắt đi, inactive memory càng chiếm nhiều(kỹ thuật Disk Caching của Linux)

Khi mở lên 1 process mới, nếu hệ thống thiếu RAM thì Linux sẽ tự động chuyển vùng bộ nhớ Inactive vào Swap và dành toàn bộ memory cho active process. Như vậy, hệ thống không bị quá tải.

Kết luận, dấu hiệu để nhận biết hệ thống có đang thiếu RAM hay không đó là bạn hãy nhìn vào Swap, nếu Swap sử dụng nhiều chứng tỏ đang bị thiếu RAM, lúc này cần nâng cấp bộ nhớ cho VPS/Server.

**1.3. Sử dụng lệnh free**

	free -m

Cùng đối với lệnh trên mà thực hiện trên Centos 6 hiển thị thêm 1 dòng kết quả so với Centos 7 và Ubuntu.

Centos 7 /Ubuntu

![](https://i.imgur.com/eUy6UxB.png)

Đối với ví dụ trên có thể hiểu: Hệ thống có tổng 7821Mb Ram đã sử dụng 5603 MB hiện còn trống 1034MB và 1183MB sử dụng là cache. Lượng RAM trống thực tế mà các ứng dụng có thể sử dụng được là 1535MB. SWAP 8063 MB chưa được dùng đến.

total = used + free + buff/cache

available = total - used 

Centos 6

![](https://i.imgur.com/WsANvYx.png)

Hệ thống có tổng 966 Mb RAM, đã sử dụng 193MB RAM còn tróng 802MB RAM. SWAP 2G chưa được dùng đến.

Với tùy chọn -m các số liệu sẽ là MB. Cột có tên used cho biết bộ nhớ đã được sử dụng bởi hệ thống với tổng số bộ nhớ sẵn có ở cột total. 

Dòng thứ hai cho biết có 802MB trống, đây là bộ nhớ trống ở dòng thứ nhất được cộng thêm bộ đệm và bộ nhớ tạm.

Dòng 2: Used + free = total

-/+ buffers/cache ở cột free. Đó chính dung lượng RAM đang trống, dung lượng RAM này sẽ luôn ưu tiên cho ứng dụng của bạn khi nó khởi chạy và chỉ số tại cột cached sẽ tự động giảm xuống

* **Cách xóa cache server**

inodes thể hiện cấu trúc dữ liệu cho một tệp tin (bản chất inodes là số file + folder).

dentries là một cấu trúc đại diện cho một thư mục. Dentries là các component của một path + file name, ví dụ file /usr/bin/test sẽ tạo ra 4 dentries: /, usr, bin và test.

Hai cấu trúc trên có thể được sử dụng để xây dựng một bộ nhớ cache đại điện cho cấu trúc tệp tin trong ổ đĩa. Để có được một list, OS có thể di chuyển tới các dentries để tìm nếu có thư mục ở đó sẽ liệt kê các nội dùng của nó (chính là các inode). Nếu không có sẽ vào ổ đĩa và độc nó vào bộ nhớ để được sử dụng lại.

PageCache có thể chứa bất kỳ ánh xạ nào. Có thể hình dùng buffered I/O, memory mapped files, paged areas of executables hay bất cứ thứ gì mà OS có thể chứa trong bộ nhớ từ một tệp.

Page cache là thông tin nằm trong cột cache khi bạn dùng free command để xem. Bất cứ khi có sự ghi data nào từ memory xuống disk thì data đó đều nằm luôn trong cache vì xác suất data vừa được ghi sẽ được đọc lại là khá cao.

https://kipalog.com/posts/Tim-hieu-to-chuc-memory-va-slab-trong-linux-kernel

+Chỉ xóa cached

sync; echo 1 > /proc/sys/vm/drop_caches

+Xóa dentries và inodes.

sync; echo 2 > /proc/sys/vm/drop_caches

+Xóa PageCache, dentries và inodes.

sync; echo 3 > /proc/sys/vm/drop_caches

Xóa cache sẽ làm app chạy trên linux chậm đi khi xử lý

* **used**: dung lượng ram đã dùng

* **free**: dung lượng ram còn trống (vùng bộ nhớ hiện tại chưa được dùng cho bất cứ điều gì)

* **cached và buffers**: Cả Cached và Buffers đều có ý nghĩa là vùng lưu trữ tạm, nhưng mục đích sử dụng thì khác nhau, tổng quan thì có một số điểm sau:

+Mục đích của cached là tạo ra một vùng nhớ tốc độ cao nhằm tăng tốc quá trình đọc/ghi file ra đĩa, trong khi buffers là tạo ra 1 vùng nhớ tạm có tốc độ bình thường, mục đích để gom data hoặc giữ data để dùng cho mục đích nào đó.

+Cached được tạo từ static RAM (SRAM) nên nhanh hơn dynamic RAM (DRAM) dùng để tạo ra buffers.

+Buffers thường dùng cho các tiến trình input/output, trong khi cached chủ yếu được dùng cho các tiến trình đọc/ghi file ra đĩa.

+Cached có thể là một phần của đĩa (đĩa có tốc độ cao) hoặc RAM trong khi buffers chỉ là một phần của RAM (không thể dùng đĩa để tạo ra buffers).

+shared: Đây là bộ nhớ chia sẻ giữa các tiến trình, bộ nhớ đang được sử dụng như các bộ đệm (lưu trữ tạm thời) bởi hạt nhân

* **Swap Space**: được sử dụng khi dung lượng bộ nhớ vật lý (RAM) đầy. Nếu hệ thống cần nhiều tài nguyên bộ nhớ hơn và bộ nhớ RAM đầy.

* **available** là lượng RAM sẵn sàng sử dụng cho các yêu cầu tiếp. (Lượng RAM sắn có để phân bố cho một tiến trình mới hoặc tiến trình hiện có).

## 2. CPU ##

**2.1. Một số lệnh kiểm tra thông số server**

Kiểm tra hãng nhà sản xuất CPU

	cat /proc/cpuinfo | grep vendor | uniq

![](https://i.imgur.com/ZCniwzo.png)


Kiểm tra tên CPU

	cat /proc/cpuinfo | grep "model name" | uniq

![](https://i.imgur.com/bTBdwCY.png)

Kiểm tra số physical processor (Số socket)

	cat /proc/cpuinfo | grep 'physical id' | uniq
	
![](https://i.imgur.com/0skjUYE.png)

Kiểm tra tổng số core

	cat /proc/cpuinfo | grep 'core id' | uniq
![](https://i.imgur.com/IjrUKo7.png)
	
Kiểm tra tổng số thread

	cat /proc/cpuinfo | grep processor | uniq | wc -l
![](https://i.imgur.com/YIat5dU.png)

Số thread = số core = 4 => mỗi core có 1 thread => không chạy Hyper Threading.

Kiểm tra thông tin tổng quan về CPUKiểm tra thông tin tổng quan về CPU

![](https://i.imgur.com/wv1BhME.png)

 Check server ảo hay thật

	dmidecode -s system-product-name

![](https://i.imgur.com/mpeig5V.png)

## 2.2. Sử dụng lệnh top để hiển thị hiệu năng của server ##

	top

![](https://i.imgur.com/sTW40RX.png)


Nhấn phím 1 để hiển thị thông tin từng CPU 1

Ngoài ra còn các hot key khác như

t: Ẩn/Hiện các thông tin tóm tắt (Dòng Tasks, CPU)

m: Ẩn/Hiện thông tin về memory

f: Hiện thị, giải thích ý nghĩa, thay đổi thứ tự hiển thị các cột của phần thông tin các process (Title của cột có nền trắng).

r:	Renice command.

k: Kill command.

![](https://i.imgur.com/Vbf0EpR.png)

* **Thông số dòng đầu tiên**

		top - 11:01:31 up 6 days, 18:08,  1 user,  load average: 2.71, 2.50, 2.46

Thời gian hiện tại là: 11:01:31

Số ngày server up: 6 ngày

Số lượng user đang login: 2


Load trung bình của server trong 1/5/15 phút: 2.71, 2.50, 2.46

load average được thể hiện trong ba khoảng thời gian khác nhau: trong 1, 5 và 15 phút. Giá trị lớn nhất của load average phụ thuộc vào số lõi (core) của CPU, nếu CPU có:

	 1 lõi: thì load average có giá trị lớn nhất là 1.00
	 2 lõi: là 2.00
	 8 lõi: là 8.00

Thông thường với một máy chủ có 1 Core CPU, không sử dụng Hyper Threading thì ngưỡng hoạt động trong 1 phút của hệ thống sẽ là khoảng 0.7, Nếu Load average của vượt quá ngưỡng trên cần kiểm tra lại xem process nào đang overload hoặc có phương hướng nâng cấp tài nguyên của hệ thống lên thêm nữa.

* **Thông số dòng thứ 2: Thông tin các tiến trình đang hoạt động trên hệ thống**

	Tasks: 316 total,   1 running, 314 sleeping,   0 stopped,   1 zombie

Total: 316 tiến trình hiện có

Running: Có 1 tiến trình đang chạy

Sleeping: 314 tiến trình đang sleep

Stop: 0 tiến trình đang stop

Zoombie: một tiến trình đã ngừng hoạt động nhưng chưa được xử lý sạch. Những chương trình sau khi thoát để lại tiến trình Zombie thì điều đó đồng nghĩa với việc chương trình đó được lập trình không tốt.

* **Thông số dòng 3: Phần trăm CPU: Bao gồm các thông số sau:**

	%Cpu(s): 27.0 us,  1.1 sy,  0.0 ni, 71.4 id,  0.3 wa,  0.0 hi,  0.2 si,  0.0 st

%us = %user(user cpu time) : đây là lượng chiếm dụng CPU khi một user khởi tạo tiến trình

%ni = %nice: đây là lượng chiếm dụng CPU khi tiến trình được tạo bởi user với độ ưu tiên là nice

%sy = %system (system cpu time): đây là lượng chiếm dụng CPU khi tiến trình được tạo ra bởi kernel (hệ thống)

%wa = %iowait(io wait cpu time): đây là lượng chiếm dụng CPU khi cpu đang trong trạng thái idle ở thời điểm phát sinh I/O request

%id = %idle: : đây là lượng chiếm dụng CPU khi cpu đang trong trạng thái idle ở thời điểm không có I/O request

%st = %steal(steal time): phần trăm do máy ảo sử dụng

%hi = %hi(hardware irq): phần trăm để xử lý gián đoạn phần cứng

%si = %si(software irq): phần trăm để xử lý gián đoạn phần mềm

* **Thông số dòng 4: Thông tin về RAM**

	KiB Mem :  8009256 total,  1334344 free,  5707792 used,   967120 buff/cache

Hệ thống có tổng 8009256 Kb RAM hiện tại đang free 1334344 Kb đã sử dụng 5707792 Kb và 967120 Kb dành cho buff/cache

* **Thông số dòng thứ 5: Thông tin về SWAP**

	KiB Swap:  8257532 total,  8257532 free,        0 used.  1575296 avail Mem

Hệ thống có 8257532 Kb SWAP hiện chưa dùng vẫn còn free 8257532 Kb, RAM sẵn sàng cho sử dụng là 1575296 Kb. 

Thông số về RAM, SWAP hiển thị ở đây giống với khi dùng lệnh free -m

* **Các dòng còn lại hiển thị chi tiết thông số của các tiến trình**

![](https://i.imgur.com/EqtZxtJ.png)

PID: Process ID

User: User thực hiện Process trên.

PR: Độ ưu tiên của Process (Mức độ ưu tiên của tiến trình, từ -20 (rất quan trọng) đến 19 (không quan trọng))

NI: Giá trị nice value của tiến trình, giá trị âm tăng độ ưu tiên của Process, giá trị dương giảm độ ưu tiên của Process.

VIRT: Dung lượng RAM ảo cho việc thực hiện Process.

RES: Dung lượng RAM thực chạy Process.

SHR: Dung lượng RAM share cho Process.

S : Trạng thái Process đang hoạt động.

	R (running): đang chạy
	D (sleeping): đang tạm nghỉ, có thể không bị gián đoạn (interrupted)
	S (sleeping): đang tạm nghỉ, có thể bị gián đoạn (interrupted)
	T: đã dừng hẳn
	Z (zombie): chưa dừng hẳn (hoặc bị treo)


Các trạng thái này có liên quan đến thống kê số lượng các tác vụ ở phần trên.

	%CPU: Phần trăm CPU do tiến trình sử dụng (trong lần cập nhật cuối – không phải thời gian thực).
	
	%MEM: Phần trăm RAM do tiến trình sử dụng (trong lần cập nhật cuối – không phải thời gian thực).
	
	TIME+: Thời gian cộng dồn mà tiến trình (gồm cả tiến trình con) đã chạy.
	
	COMMAND: Tên của tiến trình hoặc đường dẫn đến lệnh dùng để khởi động tiến trình đó.


**2.3. Sử dụng lệnh sysstat**
	
	yum install sysstat

* Kiểm tra tài nguyên CPU được sử dụng ở đâu

		sar -u 3 10 

server sẽ tiến hành kiểm tra 10 lần, mỗi lần cách nhau 3s

	![](https://i.imgur.com/pPjcbPu.png)

* Context switch

Voluntary context switch: Tiến trình tự nguyện nhường lại CPU sau khi chạy hết thời gian dự kiến của nó hoặc nó yêu cầu sử dụng tài nguyên hiện không khả dụng.

Involuntary context switch: Tiến trình bị gián đoạn và nhường lại CPU trước khi hoàn tất thời gian chạy theo lịch trình của nó do hệ thống xác định một tiến trình ưu tiên cao hơn cần thực thi.

Lệnh hiển thị context switch

	pidstat -w 10 1

![](https://i.imgur.com/niwt6Bq.png)

## 3. DISK ##

	df -h

![](https://i.imgur.com/86ILlM9.png)


Size: Tổng kích thước dung lượng

Used: Dung lượng đã sử dụng

Avail: Dung lượng trống còn lại

%use: Phần trăm dung lượng đã sử dụng

Mounted on: Đường dẫn khởi tạo

tmpfs là temporary filesystem = temporary storage (vùng lưu trữ tạm) với khả năng truy cập đọc và ghi rất nhanh trên vùng lưu trữ được đó. Quan trọng là chúng ta cần nhớ rằng, dữ liệu trên vùng lưu trữ tmpfs sẽ bị mất khi hệ thống bị reboot hay không, cực kì thích hợp để chứa dữ liệu cache site của website trên vùng tmpfs.

* Liêt kê danh sách thông tin tất cả các thiết bị khối, đó là các phân vùng ổ đĩa cứng và các thiết bị lưu trữ khác như ổ đĩa quang và ổ đĩa flash

	lsblk

![](https://i.imgur.com/phAFn4k.png)

## 4. Network ##

**4.1. Sử dụng lệnh iftop**

	yum -y install epel-release	
	yum -y install iftop


- Để xem lưu lượng băng thông

		iftop

![](https://i.imgur.com/h641yX4.png)

Để xem ip nguồn port đích, chỉ cần nhấn phím SHIFT + S và phím SHIFT + D. Nó sẽ hiển thị lưu lượng mạng truy cập cùng với các port nguồn và đích.

+Trên đỉnh của màn hình được sử dụng để chỉ việc sử dụng băng thông của mỗi kết nối mạng được liệt kê dưới đây. Thông tin trên đỉnh màn hình cho băng thông mỗi kết nối mạng đang sử dụng.

+Ở trung tâm, một danh sách của tất cả các kết nối mạng trên giao diện giám sát được hiển thị. Các mũi tên ở cuối mỗi dòng chỉ ra hướng đi của lưu lượng ra và vào.

+Ba cột cuối cùng cho thấy việc sử dụng băng thông trung bình cho mỗi kết nối trong 2, 10, và 40 giây cuối cùng.

+Phần ở dưới cùng của màn hình hiển thị số liệu thống kê lưu lượng tổng thể bao gồm cả lưu lượng được truyền Tx, lưu lượng được nhận Rx và giá trị TOTAL thể hiện tổng lưu lượng của cả Tx và Rx.

**4.2. Sử dụng lệnh sysstat**

		yum install sysstat


![](https://i.imgur.com/WqmJ1cK.png)


+ IFACE: tên của giao diện mạng mà thống kê được báo cáo.
+ Rxpck/s: tổng số gói tin nhận được mỗi giây.
+ Txpck/s: tổng số gói được truyền mỗi giây.
+ RxkB/s: tổng số kilobyte nhận được mỗi giây.
+ TxkB/s: tổng số kilobyt truyền qua mỗi giây.
+ Rxcmp/s: số lượng gói tin nén nhận được mỗi giây.
+ Txcmp/s: số lượng gói tin nén được truyền đi mỗi giây.
+ Rxmcst/s: số lượng các gói tin Multicast nhận được mỗi giây.


Để xem lưu lượng băng thông của một interface cụ thể, sử dụng lệnh sau:

	iftop -i ens160

Theo mặc định iftop sẽ hiển thị tất cả lưu lượng truy cập theo kilo/mega/giga bits mỗi giây. Để hiển thị lưu lượng truy cập theo byte thay vì bit thì thêm tham số -B (Capital B).

	 iftop -i ens160 -B

Để hiển thị lưu lượng truy cập đang xảy ra trên port nào, sử dụng tham số -P và -N

	iftop -i ens160 -P -N

Để xem luồng gói tin trong và ngoài của dai mạng, sử dụng lệnh sau.

	iftop -F 172.16.4.0/24
