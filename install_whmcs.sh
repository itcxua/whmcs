#!/bin/bash

# ========================
# WHMCS AUTOINSTALL SCRIPT
# Author: itcxua
# ========================

# --- Базові змінні ---

domain=""
WANIP4=$(curl -s -k -m 5 -4 https://api64.ipify.org) && echo $WANIP4
email="itcxua@gmail.com"
install_dir="/var/www/$domain"
db_name="whmcs"
db_user="whmcsuser"
db_pass=$(date +%s | sha256sum | base64 | head -c 30)
whmcs_tar_url="https://github.com/itcxua/whmcs/releases/download/v8.12.1/WHMCS.v8.10.1.nulled.tar"
php_version="8.1"

read -p "Enter domain Name: " domain;
if [ -z "$domain" ]; then
  domain=$WANIP4
else
  echo $domain
fi;

# ========================
# MAIN INSTALL WHMCS
# ========================

function base_install_whmcs () {
    echo "🔄 Оновлення системи..."
    apt update && apt upgrade -y

    echo "📦 Встановлення пакетів..."
    apt install -y nginx mariadb-server php${php_version} unzip curl wget tar git
    apt install -y php${php_version}-{fpm,cli,mysql,mbstring,xml,curl,zip,bcmath,gd,intl,imap}

    echo "🗄️ Налаштування БД..."
    mysql -e "CREATE DATABASE ${db_name} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -e "CREATE USER '${db_user}'@'localhost' IDENTIFIED BY '${db_pass}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"

    echo "📥 Завантаження WHMCS..."
    mkdir -p $install_dir
    cd /tmp
    wget -O whmcs.tar "$whmcs_tar_url"
    tar -xf whmcs.tar -C $install_dir
    chown -R www-data:www-data $install_dir

    echo "⚙️ Створення Nginx-конфігу..."
    cat > /etc/nginx/sites-available/$domain <<EOF
server {
    listen 80;
    server_name $domain www.$domain;
    root $install_dir;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php${php_version}-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

    ln -s /etc/nginx/sites-available/$domain /etc/nginx/sites-enabled/
    nginx -t && systemctl reload nginx

    echo "🔒 SSL..."
    apt install -y certbot python3-certbot-nginx
    certbot --nginx -d $domain --non-interactive --agree-tos -m $email

    echo "📌 WHMCS встановлено на: https://$domain"
    echo "🗝️ Доступ до бази: $db_name / $db_user / $db_pass"
}

# ========================
# ІНТЕГРАЦІЇ / ДОПОВНЕННЯ
# ========================

function modul_cPanel () {
    echo "⚙️ Додаємо інтеграцію з cPanel..."
    mysql -u root $db_name <<EOF
INSERT INTO tblservers (name, type, hostname, ipaddress, username, password, accesshash, secure, port, active)
VALUES ('cPanel WHM', 'cpanel', 'cpanel.example.com', '1.2.3.4', 'root', '', '', 1, 2087, 1);
EOF
}

function modul_SMTP () {
    echo "📧 Налаштовуємо SMTP (Mailgun)..."
    mysql -u root $db_name <<EOF
UPDATE tblconfiguration SET value = 'mail' WHERE setting = 'MailType';
UPDATE tblconfiguration SET value = 'smtp.mailgun.org' WHERE setting = 'SMTPHost';
UPDATE tblconfiguration SET value = '587' WHERE setting = 'SMTPPort';
UPDATE tblconfiguration SET value = 'smtp_user@mailgun.org' WHERE setting = 'SMTPUsername';
UPDATE tblconfiguration SET value = 'yourSMTPpassword' WHERE setting = 'SMTPPassword';
UPDATE tblconfiguration SET value = 'tls' WHERE setting = 'SMTPSSL';
EOF
}

function modul_SMS () {
    echo "📲 Додаємо TurboSMS..."
    MODULE_DIR="$install_dir/modules/notifications/turbosms"
    mkdir -p $MODULE_DIR
    echo "<?php // TurboSMS модуль (заглушка) ?>" > $MODULE_DIR/turbosms.php
    chown -R www-data:www-data $MODULE_DIR
}

function CREATE_hostingTarif () {
    echo "📦 Створення тарифного плану..."
    mysql -u root $db_name <<EOF
INSERT INTO tblproducts (type, gid, name, description, paytype, hidden, showdomainoptions, welcomeemail)
VALUES ('hostingaccount', 1, 'Basic Hosting 1GB', 'Найпростіший хостинг тариф', 'recurring', 0, 1, 1);
EOF
}

function post_install_autologin () {
    echo "🔐 Автологін після встановлення..."
    CONFIG_FILE="$install_dir/configuration.php"
    if [ -f "$CONFIG_FILE" ]; then
        sed -i "s/^\$db_username.*/\$db_username = \"$db_user\";/" $CONFIG_FILE
        sed -i "s/^\$db_password.*/\$db_password = \"$db_pass\";/" $CONFIG_FILE
        sed -i "s/^\$db_name.*/\$db_name = \"$db_name\";/" $CONFIG_FILE
    fi
}

# ========================
# СТАРТ УСТАНОВКИ
# ========================

base_install_whmcs
modul_cPanel
modul_SMTP
modul_SMS
CREATE_hostingTarif
post_install_autologin
