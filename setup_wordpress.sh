#!/bin/bash

# Script tự động cài đặt WordPress, thiết lập SSL trên Ubuntu 22.04
# Thông tin tài khoản: lens/Lens123456789
# Tên miền: lensdou.com
# Email: daophuongkhanh201@gmail.com

# Cập nhật hệ thống
echo "===== Cập nhật hệ thống ====="
apt update && apt upgrade -y

# Cài đặt các gói cần thiết
echo "===== Cài đặt các gói cần thiết ====="
apt install -y apache2 mariadb-server php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip unzip wget certbot python3-certbot-apache

# Bật và khởi động Apache
systemctl enable apache2
systemctl start apache2

# Cấu hình tường lửa
echo "===== Cấu hình tường lửa ====="
apt install -y ufw
ufw allow OpenSSH
ufw allow 'Apache Full'
ufw --force enable

# Cấu hình MariaDB
echo "===== Cấu hình MariaDB ====="
mysql_secure_installation <<EOF

y
Lens123456789
Lens123456789
y
y
y
y
EOF

# Tạo database cho WordPress
echo "===== Tạo database cho WordPress ====="
mysql -u root -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -u root -e "CREATE USER 'lens'@'localhost' IDENTIFIED BY 'Lens123456789';"
mysql -u root -e "GRANT ALL ON wordpress.* TO 'lens'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Cấu hình Apache cho trang web
echo "===== Cấu hình Apache cho trang web ====="
cat > /etc/apache2/sites-available/lensdou.com.conf << 'EOL'
<VirtualHost *:80>
    ServerAdmin daophuongkhanh201@gmail.com
    ServerName lensdou.com
    ServerAlias www.lensdou.com
    DocumentRoot /var/www/lensdou.com/wordpress
    
    <Directory /var/www/lensdou.com/wordpress>
        AllowOverride All
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Tạo thư mục cho trang web
mkdir -p /var/www/lensdou.com

# Tải và cài đặt WordPress
echo "===== Tải và cài đặt WordPress ====="
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cp -R wordpress /var/www/lensdou.com/
chown -R www-data:www-data /var/www/lensdou.com/

# Cấu hình WordPress
echo "===== Cấu hình WordPress ====="
cp /var/www/lensdou.com/wordpress/wp-config-sample.php /var/www/lensdou.com/wordpress/wp-config.php
sed -i "s/database_name_here/wordpress/" /var/www/lensdou.com/wordpress/wp-config.php
sed -i "s/username_here/lens/" /var/www/lensdou.com/wordpress/wp-config.php
sed -i "s/password_here/Lens123456789/" /var/www/lensdou.com/wordpress/wp-config.php

# Tạo khóa bảo mật cho WordPress
SALT=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
SALT="${SALT//$'\n'/\\n}"
sed -i "/define( 'AUTH_KEY'/,/define( 'NONCE_SALT'/c\\$SALT" /var/www/lensdou.com/wordpress/wp-config.php

# Kích hoạt trang web
a2ensite lensdou.com.conf
a2enmod rewrite
systemctl restart apache2

# Cài đặt SSL bằng Certbot
echo "===== Cài đặt SSL ====="
certbot --apache --non-interactive --agree-tos --email daophuongkhanh201@gmail.com -d lensdou.com -d www.lensdou.com

# Thiết lập tự động gia hạn SSL
echo "0 3 * * * /usr/bin/certbot renew --quiet" | crontab -

echo "===== Hoàn tất cài đặt ====="
echo "WordPress đã được cài đặt tại: http://lensdou.com"
echo "Bạn có thể truy cập trang quản trị tại: http://lensdou.com/wp-admin"
echo "Tài khoản quản trị: lens"
echo "Mật khẩu: Lens123456789"
echo "SSL đã được cài đặt cho trang web lensdou.com"
