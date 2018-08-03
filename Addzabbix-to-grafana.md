# Add zabbix to grafana #

## 1. Download plugin zabbix-garafna về Server grafana ##

https://grafana.com/plugins/alexanderzobnin-zabbix-app

![Imgur](https://i.imgur.com/nTSvsHx.png)

+ Download với định dạng zip về máy tính cá nhân -> giải nén và FTP lên thư mục plugin của grafana (/var/lib/grafana/plugins)

![Imgur](https://i.imgur.com/iywjnJ0.png)

[Imgur](https://i.imgur.com/T2MnFR7.png)

+ SSH vào server grafana restart service

        systemctl restart apache2
        systemctl restart carbon-cache
        systemctl restart grafana-server

+ Kiểm tra và enable plugin zabbix

![Imgur](https://i.imgur.com/IDIvYYS.png)

Enable plugin

![Imgur](https://i.imgur.com/JUFlVdF.png)

## 2. Cấu hình để grafana tương tác với zabbix ##

Biểu tượng bánh răng -> Datasource

![Imgur](https://i.imgur.com/msjMuiO.png)


+Add datasource

![Imgur](https://i.imgur.com/2u7IkG1.png)


![Imgur](https://i.imgur.com/C3eIn6p.png)

Name: Tên đặt tùy ý

Type: Lựa chọn zabbix

URL: http://IP_Zabbixserver/zabbix/api_jsonrpc.php


![Imgur](https://i.imgur.com/4M5VwZU.png)

Username/Password: là username/password của zabbix server

Xác nhận Save&Test

![Imgur](https://i.imgur.com/Pr4ZHwJ.png)


Zabbix đã add vào grafana thành công

![Imgur](https://i.imgur.com/AdztS5V.png)

![Imgur](https://i.imgur.com/qEfhiLg.png)













