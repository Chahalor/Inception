#!/bin/sh

set -e

# =========================
# Variables
# =========================
DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"

# =========================
# Préparation système
# =========================
mkdir -p /run/mysqld
mkdir -p "$DATADIR"

chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql "$DATADIR"

# =========================
# Init DB si nécessaire
# =========================
ls -la /var/lib/mysql	# rm
rm -rf /run/mysqld/mysqld	# rm
if [ ! -d "$DATADIR/mysql" ]; then
	echo "[MariaDB] Initialisation du data directory"

	mysql_install_db \
		--user=mysql \
		--datadir="$DATADIR"

	echo "[MariaDB] Démarrage temporaire (bootstrap)"
	mysqld --user=mysql --skip-networking &

	# attendre le socket
	while [ ! -S "$SOCKET" ]; do
		sleep 1
	done

	echo "[MariaDB] Configuration SQL"

	mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

	echo "[MariaDB] Arrêt bootstrap"
	mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
else
	echo "[DEBUG] no init needed"
fi

# =========================
# Lancement final
# =========================
echo "[MariaDB] Lancement final"
exec mysqld \
		--user=mysql \
		--bind-address=0.0.0.0 \
		--console




# #!/bin/sh

# set -e

# DATADIR="/var/lib/mysql"
# SOCKET="/run/mysqld/mysqld.sock"

# mkdir -p /run/mysqld
# mkdir -p ${DATADIR}
# chown -R mysql:mysql /run/mysqld
# chown -R mysql:mysql ${DATADIR}

# if [ ! -d "${DATADIR}/mysql" ]; then
# 	echo "[MariaDB] Initialisation du data directory"

# 	mysql_install_db \
# 		--user=mysql \
# 		--datadir=${DATADIR}

# 	echo "[MariaDB] Démarrage temporaire (bootstrap)"
# 	mysqld --user=mysql --skip-networking &

# 	# while ! mysqladmin ping --silent; do
# 	# 	sleep 1
# 	# done
# 	while [ ! -S "$SOCKET" ]; do
# 		sleep 1
# 	done

# 	echo "[MariaDB] Configuration SQL"

# # 	mysql << EOF # TODO: retry all commented lignes later (addapt them to the new env vars idiot)
# # CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
# # CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# # GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

# # ALTER USER 'root'@'localhost'
# # IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';

# # FLUSH PRIVILEGES;
# # EOF
# 	mysql --protocol=socket -S "$SOCKET" << EOF
# CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

# DROP USER IF EXISTS 'root'@'localhost';
# CREATE USER 'root'@'localhost'
# IDENTIFIED WITH mysql_native_password
# BY '${MYSQL_ROOT_PASSWORD}';

# FLUSH PRIVILEGES;
# EOF


# 	echo "[DEBUG] SQL applied"	# rm
# 	echo "[MariaDB] Arrêt du serveur temporaire"
# 	mysqladmin shutdown
# fi

# echo "[MariaDB] Lancement final"
# exec mysqld --user=mysql --bind-address=0.0.0.0
