#!/bin/bash
set -e

INIT_FLAG="/var/lib/mysql/.initialized"

echo "MariaDB entrypoint running. Unfortunately."

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -f "$INIT_FLAG" ]; then
	echo "First container start. Performing full MariaDB initialization."

	# Clean any broken Debian pre-init
	rm -rf /var/lib/mysql/*

	mysql_install_db \
		--user=mysql \
		--datadir=/var/lib/mysql

	echo "Starting MariaDB for initial configuration..."
	mariadbd --datadir=/var/lib/mysql --skip-networking &
	pid="$!"

	until mysqladmin ping --silent; do
		sleep 1
	done

	if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
		echo "MYSQL_ROOT_PASSWORD is required"
		exit 1
	fi

	mysql <<-EOSQL
		CREATE USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
		FLUSH PRIVILEGES;
EOSQL

	touch "$INIT_FLAG"
	mysqladmin shutdown
	wait "$pid"

	echo "MariaDB initialization completed."
else
	echo "Existing database detected. Skipping initialization."
fi

echo "Starting MariaDB normally."
exec mariadbd --datadir=/var/lib/mysql
