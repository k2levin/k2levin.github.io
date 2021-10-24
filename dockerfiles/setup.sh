#!/bin/sh

# running by root user

set -e

# timezone UTC+08 setup
apk add --update tzdata
cp /usr/share/zoneinfo/Asia/Singapore /etc/localtime
echo 'Asia/Singapore' > /etc/timezone
apk del tzdata

# nginx optimize for production
sed -i 's/user nginx;/# user nginx;/1' /etc/nginx/nginx.conf
sed -i "s/worker_processes auto;/worker_processes $(nproc);/1" /etc/nginx/nginx.conf
sed -i 's/worker_connections 1024;/worker_connections 2048;/1' /etc/nginx/nginx.conf
sed -i 's/keepalive_timeout 65;/keepalive_timeout 30;/1' /etc/nginx/nginx.conf
sed -i 's/access_log \/var\/log\/nginx\/access.log main;/access_log off;/1' /etc/nginx/nginx.conf
sed -i 's/error_log \/var\/log\/nginx\/error.log warn;/error_log stderr warn;/1' /etc/nginx/nginx.conf
install -d -o www-data -g www-data /run/nginx
chown -R www-data:www-data /var/lib/nginx /var/log/nginx
