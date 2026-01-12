#!/bin/sh

set -e

DATADIR="/var/lib/mysql"
RUN_DIR="/run/mysqld"
SOCKET="$RUN_DIR/mysqld.sock"

require_var() {
	if [ -z "$1" ]; then
		echo "[MariaDB] Error: required environment variable is missing"
		exit 1
	else
		echo "'$1' is set"
	fi
}

require_var "$MYSQL_DATABASE"
require_var "$MYSQL_USER"
require_var "$MYSQL_PASSWORD"
require_var "$MYSQL_ROOT_PASSWORD"

mkdir -p "$DATADIR" "$RUN_DIR"
chown -R mysql:mysql "$DATADIR" "$RUN_DIR"

if [ ! -d "$DATADIR/mysql" ]; then
	echo "[MariaDB] Initializing database"
	mariadb-install-db --user=mysql --datadir="$DATADIR"

	echo "[MariaDB] Starting temporary server"
	mariadbd --user=mysql --datadir="$DATADIR" --skip-networking --socket="$SOCKET" &
	pid="$!"

	for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30; do
		if mariadb-admin --socket="$SOCKET" ping >/dev/null 2>&1; then
			break
		fi
		sleep 1
	done

	if ! mariadb-admin --socket="$SOCKET" ping >/dev/null 2>&1; then
		echo "[MariaDB] Error: temporary server failed to start"
		exit 1
	fi

	mariadb --socket="$SOCKET" <<-SQL
		CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
		CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
		GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
		FLUSH PRIVILEGES;
SQL

	mariadb-admin --socket="$SOCKET" shutdown
	wait "$pid"
fi

echo "[MariaDB] Starting server"
exec mariadbd --user=mysql --datadir="$DATADIR" --bind-address=0.0.0.0
