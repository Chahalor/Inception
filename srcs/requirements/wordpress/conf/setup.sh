#!/bin/sh

set -e

WP_DIR="/var/www/html"

echo "[WordPress] Waiting for MariaDB..."
while ! mysqladmin ping \
	-h "$DB_HOST" \
	-u"$WP_USER" \
	-p"$WP_USER_PASSWORD" \
	--silent; do
	sleep 1
done
echo "[WordPress] MariaDB is up"

if [ ! -f "$WP_DIR/wp-config.php" ]; then
	echo "[WordPress] Installing WordPress"

	curl -s https://wordpress.org/latest.tar.gz | tar xz --strip 1 -C "$WP_DIR"
	cp /wp-config.php "$WP_DIR/wp-config.php"

	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp

fi

chown -R www-data:www-data "$WP_DIR"

echo "[WordPress] Configuring PHP-FPM to listen on TCP"

sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf
sed -i 's|^;*listen.allowed_clients =.*|listen.allowed_clients = 0.0.0.0|' \
	/etc/php/8.2/fpm/pool.d/www.conf

echo "[WordPress] Starting PHP-FPM"
exec php-fpm8.2 -F
