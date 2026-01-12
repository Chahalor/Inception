#!/bin/bash
set -e

INIT_FLAG="/var/lib/mysql/.initialized"

echo "MariaDB entrypoint running. Still."

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -f "$INIT_FLAG" ]; then
	echo "First container start. Performing full MariaDB initialization."

	rm -rf /var/lib/mysql/*

	mysql_install_db \
		--user=mysql \
		--datadir=/var/lib/mysql

	echo "Starting MariaDB for initial configuration..."

	mariadbd \
		--user=mysql \
		--datadir=/var/lib/mysql \
		--skip-networking &
	pid="$!"

	until mysqladmin ping --silent; do
		sleep 1
	done

	# Sanity checks
	: "${MYSQL_ROOT_PASSWORD:?MYSQL_ROOT_PASSWORD is required}"
	: "${MYSQL_DATABASE:?MYSQL_DATABASE is required}"
	: "${MYSQL_USER:?MYSQL_USER is required}"
	: "${MYSQL_PASSWORD:?MYSQL_PASSWORD is required}"

	mysql <<-EOSQL
		-- Secure root
		ALTER USER 'root'@'localhost'
		IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

		CREATE USER IF NOT EXISTS 'root'@'%'
		IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

		GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

		-- WordPress database and user
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
		IDENTIFIED BY '${MYSQL_PASSWORD}';

		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

		FLUSH PRIVILEGES;
	EOSQL

	touch "$INIT_FLAG"

	mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
	wait "$pid"

	echo "MariaDB initialization completed."
else
	echo "Existing database detected. Skipping initialization."
fi

echo "Starting MariaDB normally."
exec mariadbd --user=mysql --datadir=/var/lib/mysql


# #!/bin/bash
# set -e

# INIT_FLAG="/var/lib/mysql/.initialized"

# echo "MariaDB entrypoint running. Still."

# mkdir -p /var/run/mysqld
# chown -R mysql:mysql /var/run/mysqld
# chown -R mysql:mysql /var/lib/mysql

# if [ ! -f "$INIT_FLAG" ]; then
# 	echo "First container start. Performing full MariaDB initialization."

# 	rm -rf /var/lib/mysql/*

# 	mysql_install_db \
# 		--user=mysql \
# 		--datadir=/var/lib/mysql

# 	echo "Starting MariaDB for initial configuration..."

# 	mariadbd \
# 		--user=mysql \
# 		--datadir=/var/lib/mysql \
# 		--skip-networking &
# 	pid="$!"

# 	until mysqladmin ping --silent; do
# 		sleep 1
# 	done

# 	if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
# 		echo "MYSQL_ROOT_PASSWORD is required"
# 		exit 1
# 	fi

# 	mysql <<-EOSQL
# 		-- Force password auth for root@localhost
# 		ALTER USER 'root'@'localhost'
# 		IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

# 		-- Ensure root can connect over the network
# 		CREATE USER IF NOT EXISTS 'root'@'%'
# 		IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

# 		GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
# 		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

# 		FLUSH PRIVILEGES;
# 	EOSQL

# 	touch "$INIT_FLAG"
# 	mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
# 	wait "$pid"

# 	echo "MariaDB initialization completed."
# else
# 	echo "Existing database detected. Skipping initialization."
# fi

# echo "Starting MariaDB normally."
# exec mariadbd --user=mysql --datadir=/var/lib/mysql
