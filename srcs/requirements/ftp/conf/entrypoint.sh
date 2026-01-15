#!/bin/sh

set -e

WWW_DIR="/var/www/html"

mkdir -p "$WWW_DIR"
chown -R www-data:www-data "$WWW_DIR"
chmod -R 775 "$WWW_DIR"

exec vsftpd /etc/vsftpd.conf
