#!/bin/sh

set -e

WP_DIR="/var/www/html"

echo "[WordPress] Waiting for MariaDB..."

while ! mysqladmin ping -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASSWORD" --silent; do
	sleep 1
done

echo "[WordPress] MariaDB is available"

if [ ! -f "$WP_DIR/wp-config.php" ]; then
	echo "[WordPress] Installing WordPress"

	curl -s https://wordpress.org/latest.tar.gz | tar xz --strip 1 -C "$WP_DIR"

	cp /wp-config.php "$WP_DIR/wp-config.php"
fi

chown -R www-data:www-data "$WP_DIR"

echo "[WordPress] Starting PHP-FPM"
exec php-fpm7.4 -F
