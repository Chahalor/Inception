#!/bin/bash
set -e

echo "MariaDB entrypoint running. Again. Time is a flat circle."

# Ensure runtime directories exist
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql

# First-time initialization only
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Fresh database detected. Initializing MariaDB..."

	mysql_install_db \
		--user=mysql \
		--datadir=/var/lib/mysql

	echo "Starting MariaDB temporarily for initial setup..."
	mysqld_safe --datadir=/var/lib/mysql &
	pid="$!"

	# Wait until MariaDB is ready
	until mysqladmin ping --silent; do
		sleep 1
	done

	if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
		echo "Setting root password..."
		mysql -u root <<-EOSQL
			ALTER USER 'root'@'localhost'
			IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
			FLUSH PRIVILEGES;
EOSQL
	fi

	echo "Initial MariaDB setup complete. Shutting down temp server..."
	mysqladmin shutdown
	wait "$pid"
else
	echo "Existing database detected. Skipping initialization."
fi

echo "Starting MariaDB normally..."
exec mysqld_safe --datadir=/var/lib/mysql
