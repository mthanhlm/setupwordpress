#!/bin/bash

# Script gỡ bỏ WordPress, Apache, MariaDB, PHP và các cài đặt liên quan

echo "===== Bắt đầu gỡ bỏ các cài đặt cũ ====="

# Xóa SSL certificates
echo "===== Xóa SSL certificates ====="
certbot delete --cert-name lensdou.com

# Vô hiệu hóa site trong Apache
echo "===== Vô hiệu hóa site Apache ====="
a2dissite lensdou.com.conf

# Xóa cấu hình Apache site
echo "===== Xóa cấu hình Apache site ====="
rm -f /etc/apache2/sites-available/lensdou.com.conf

# Xóa thư mục web
echo "===== Xóa thư mục web ====="
rm -rf /var/www/lensdou.com

# Xóa database và user MySQL
echo "===== Xóa database và user MySQL ====="
mysql -e "DROP USER IF EXISTS 'lens'@'localhost';"
mysql -e "DROP DATABASE IF EXISTS wordpress;"

# Gỡ cài đặt các phần mềm (nhưng giữ lại các file cấu hình để cài đặt lại nhanh hơn)
echo "===== Gỡ cài đặt các phần mềm ====="
apt remove --purge -y certbot python3-certbot-apache

# Khởi động lại Apache
systemctl restart apache2

echo "===== Hoàn tất gỡ bỏ cài đặt ====="
echo "Bạn đã gỡ bỏ thành công WordPress, database và các cấu hình liên quan."
echo "Bạn có thể chạy script cài đặt mới bây giờ."
