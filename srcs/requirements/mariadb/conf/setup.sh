#!/bin/sh

set -e

DATADIR="/var/lib/mysql"

mkdir -p /run/mysqld
mkdir -p ${DATADIR}
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql ${DATADIR}

if [ ! -d "${DATADIR}/mysql" ]; then
	echo "[MariaDB] Initialisation du data directory"

	mysql_install_db \
		--user=mysql \
		--datadir=${DATADIR}

	echo "[MariaDB] Démarrage temporaire (bootstrap)"
	mysqld --user=mysql --skip-networking &

	while ! mysqladmin ping --silent; do
		sleep 1
	done

	echo "[MariaDB] Configuration SQL"

	mysql << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost'
IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF


	echo "[MariaDB] Arrêt du serveur temporaire"
	mysqladmin shutdown
fi

echo "[MariaDB] Lancement final"
exec mysqld --user=mysql --bind-address=0.0.0.0
