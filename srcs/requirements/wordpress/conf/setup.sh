#!/bin/sh

set -e

WP_DIR="/var/www/html"

echo "[WordPress] Waiting for MariaDB..."
while ! mysqladmin ping \
	-h "$DB_HOST" \
	-u"$DB_USER" \
	-p"$DB_PASSWORD" \
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

	echo "[WordPress] Installing core (if needed)"
	wp core install \
		--url="https://localhost" \
		--title="Inception" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email \
		--allow-root || true

	if ! wp user get "$WP_USER" --allow-root >/dev/null 2>&1; then
	echo "[WordPress] Creating additional user"
	wp user create "$WP_USER" "$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PASSWORD" \
		--role=author \
		--allow-root
	else
		echo "[WordPress] User $WP_USER already exists"
	fi

	chown -R www-data:www-data /var/www/html
	chmod -R 755 /var/www/html

fi

chown -R www-data:www-data "$WP_DIR"

echo "[WordPress] Configuring PHP-FPM to listen on TCP"

FPM_CONF="/etc/php/8.2/fpm/pool.d/www.conf"
FPM_GLOBAL_CONF="/etc/php/8.2/fpm/php-fpm.conf"

mkdir -p /run/php

sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' "$FPM_CONF"
# Allow all clients by removing listen.allowed_clients (defaults to any).
sed -i '/^;*listen.allowed_clients =/d' "$FPM_CONF"

if grep -q '^;*error_log' "$FPM_GLOBAL_CONF"; then
	sed -i 's|^;*error_log = .*|error_log = /proc/self/fd/2|' \
		"$FPM_GLOBAL_CONF"
else
	echo "error_log = /proc/self/fd/2" >> "$FPM_GLOBAL_CONF"
fi

if grep -q '^;*log_level' "$FPM_GLOBAL_CONF"; then
	sed -i 's|^;*log_level = .*|log_level = notice|' "$FPM_GLOBAL_CONF"
else
	echo "log_level = notice" >> "$FPM_GLOBAL_CONF"
fi

if grep -q '^;*clear_env' "$FPM_CONF"; then
	sed -i 's|^;*clear_env = .*|clear_env = no|' "$FPM_CONF"
else
	echo "clear_env = no" >> "$FPM_CONF"
fi

for key in DB_HOST DB_NAME DB_USER DB_PASSWORD MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD; do
	val=$(printenv "$key" || true)
	if [ -n "$val" ] && ! grep -q "^env\\[$key\\]" "$FPM_CONF"; then
		echo "env[$key] = $val" >> "$FPM_CONF"
	fi
done

if grep -q '^;*catch_workers_output' "$FPM_CONF"; then
	sed -i 's|^;*catch_workers_output.*|catch_workers_output = yes|' "$FPM_CONF"
else
	echo "catch_workers_output = yes" >> "$FPM_CONF"
fi

if grep -q '^;*php_admin_flag\\[log_errors\\]' "$FPM_CONF"; then
	sed -i 's|^;*php_admin_flag\\[log_errors\\].*|php_admin_flag[log_errors] = on|' "$FPM_CONF"
else
	echo "php_admin_flag[log_errors] = on" >> "$FPM_CONF"
fi

if grep -q '^;*php_admin_value\\[error_log\\]' "$FPM_CONF"; then
	sed -i 's|^;*php_admin_value\\[error_log\\].*|php_admin_value[error_log] = /proc/self/fd/2|' "$FPM_CONF"
else
	echo "php_admin_value[error_log] = /proc/self/fd/2" >> "$FPM_CONF"
fi

echo "[WordPress] Starting PHP-FPM"
exec php-fpm8.2 -F
