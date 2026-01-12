#!/bin/sh
set -e

RUN_DIR="/run/mysqld"
SOCKET="$RUN_DIR/mysqld.sock"

require_var() {
	if [ -z "$2" ]; then
		echo "[MariaDB] Error: $1 is not set"
		exit 1
	fi
	echo "[MariaDB] $1 is set"
}

require_var MYSQL_DATABASE "$MYSQL_DATABASE"
require_var MYSQL_USER "$MYSQL_USER"
require_var MYSQL_PASSWORD "$MYSQL_PASSWORD"

mkdir -p "$RUN_DIR"
chown -R mysql:mysql "$RUN_DIR"

echo "[MariaDB] Starting temporary server"
mysqld_safe --skip-networking --socket="$SOCKET" &

until mysqladmin --socket="$SOCKET" ping >/dev/null 2>&1; do
	sleep 1
done

echo "[MariaDB] Configuring database"

mysql --protocol=socket -S "$SOCKET" -u root <<-SQL
	CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
	FLUSH PRIVILEGES;
SQL

mysqladmin --socket="$SOCKET" -u root shutdown

echo "[MariaDB] Starting final server"
exec mysqld \
	--user=mysql \
	--bind-address=0.0.0.0 \
	--console
