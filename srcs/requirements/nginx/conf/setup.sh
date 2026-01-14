#!/bin/bash
set -e

echo "Starting nginx."

mkdir -p /run/nginx
mkdir -p /var/www/html
mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nduvoid.key \
	-out /etc/nginx/ssl/nduvoid.crt \
	-subj "/CN=nduvoid.42.fr" \
	-addext "subjectAltName=DNS:nduvoid.42.fr"


chown -R www-data:www-data /var/www/html

nginx -t

echo "Ngnix setup finished"
exec nginx -g "daemon off;"
