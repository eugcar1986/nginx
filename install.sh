#!/bin/bash
rm -rf ./install.sh
echo "user www-data;

worker_processes 1;
pid /var/run/nginx.pid;

events {
	multi_accept on;
	worker_connections 1024;
}

http {
	gzip on;
	gzip_vary on;
	gzip_comp_level 5;
	gzip_types    text/plain application/x-javascript text/xml text/css;

	autoindex on;
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;
	server_tokens off;
	include /etc/nginx/mime.types;
	default_type application/octet-stream;
	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;
	client_max_body_size 32M;
	client_header_buffer_size 8m;
	large_client_header_buffers 8 8m;

	fastcgi_buffer_size 8m;
	fastcgi_buffers 8 8m;

	fastcgi_read_timeout 600;

  include /etc/nginx/conf.d/*.conf;
}" > /etc/nginx/nginx.conf

sed -i 's/www-data/nginx/g' /etc/nginx/nginx.conf

wget -O /home/vps/public_html/index.html "http://script.hostingtermurah.net/repo/index.html"

echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php
rm /etc/nginx/conf.d/*
args='$args'
uri='$uri'
document_root='$document_root'
fastcgi_script_name='$fastcgi_script_name'
echo "server {
	listen       85;
	server_name  127.0.0.1 localhost;
	access_log /var/log/nginx/vps-access.log;
	error_log /var/log/nginx/vps-error.log error;
	root   /home/vps/public_html;

	location / {
		index  index.html index.htm index.php;
		try_files $uri $uri/ /index.php?$args;
	}

	location ~ \.php$ {
		include /etc/nginx/fastcgi_params;
		fastcgi_pass  127.0.0.1:9000;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	}
}" > /etc/nginx/conf.d/vps.conf
sed -i 's/apache/nginx/g' /etc/php-fpm.d/www.conf
chmod -R +rx /home/vps
service php-fpm restart
