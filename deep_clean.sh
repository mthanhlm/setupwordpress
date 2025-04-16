#!/bin/bash

echo "===== Xử lý lỗi Apache và gỡ bỏ triệt để hệ thống ====="

# Lấy thông tin chi tiết về lỗi
echo "===== Thông tin chi tiết về lỗi Apache ====="
systemctl status apache2.service
journalctl -xeu apache2.service | tail -n 50

# Tắt cưỡng chế Apache
echo "===== Tắt cưỡng chế Apache ====="
systemctl stop apache2.service || true
systemctl kill apache2.service || true
killall -9 apache2 || true

# Kiểm tra xem Apache có chạy không
echo "===== Kiểm tra xem Apache có còn chạy không ====="
ps aux | grep apache

# Vô hiệu hóa các trang web có thể gây lỗi
echo "===== Vô hiệu hóa các trang web có thể gây lỗi ====="
a2dissite * || true
a2disconf * || true
a2dismod ssl || true

# Sửa chữa cài đặt Apache
echo "===== Sửa chữa cài đặt Apache ====="
apt-get update
dpkg --configure -a
apt-get install -f -y

# Khôi phục file cấu hình Apache mặc định
echo "===== Khôi phục file cấu hình Apache mặc định ====="
if [ -f /etc/apache2/apache2.conf.dpkg-dist ]; then
    cp /etc/apache2/apache2.conf.dpkg-dist /etc/apache2/apache2.conf
fi

# Gỡ bỏ hoàn toàn các gói
echo "===== Gỡ bỏ hoàn toàn các gói ====="
apt-get remove --purge -y apache2 apache2-* libapache2-mod-* php* mariadb-server mariadb-client mysql-common certbot python3-certbot-apache
apt-get autoremove -y
apt-get autoclean -y

# Xóa các thư mục cấu hình
echo "===== Xóa các thư mục cấu hình ====="
rm -rf /etc/apache2
rm -rf /etc/php
rm -rf /etc/mysql
rm -rf /etc/letsencrypt
rm -rf /var/www/lensdou.com
rm -rf /var/lib/mysql
rm -rf /var/log/apache2
rm -rf /var/log/mysql

# Làm sạch các tập tin và thư mục tạm
echo "===== Làm sạch các tập tin và thư mục tạm ====="
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "===== Cài đặt lại các gói cần thiết ====="
apt-get update
apt-get install -y apache2 mariadb-server php php-mysql

# Kiểm tra cài đặt Apache mới
echo "===== Kiểm tra cài đặt Apache mới ====="
apache2 -t
systemctl start apache2
systemctl status apache2

echo "===== Hoàn tất xử lý lỗi và gỡ bỏ ====="
echo "Hệ thống đã được làm sạch và Apache đã được cài đặt lại."
echo "Bạn có thể chạy lại script cài đặt WordPress từ đầu."
