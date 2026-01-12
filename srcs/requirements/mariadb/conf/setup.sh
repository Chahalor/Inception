
#!/bin/sh

set -e

DATADIR="/var/lib/mysql"
SOCKET="/run/mysqld/mysqld.sock"

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

	# while ! mysqladmin ping --silent; do
	# 	sleep 1
	# done
	while [ ! -S "$SOCKET" ]; do
		sleep 1
	done


	echo "[MariaDB] Configuration SQL"

# 	mysql << EOF # TODO: retry all commented lignes later (addapt them to the new env vars idiot)
# CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

# ALTER USER 'root'@'localhost'
# IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';

# FLUSH PRIVILEGES;
# EOF
	mysql --protocol=socket -S "$SOCKET" << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

DROP USER IF EXISTS 'root'@'localhost';
CREATE USER 'root'@'localhost'
IDENTIFIED WITH mysql_native_password
BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF


	echo "[DEBUG] SQL applied"	# rm
	echo "[MariaDB] Arrêt du serveur temporaire"
	mysqladmin shutdown
fi

echo "[MariaDB] Lancement final"
exec mysqld --user=mysql --bind-address=0.0.0.0


# #!/bin/sh
# set -e

# RUN_DIR="/run/mysqld"
# SOCKET="$RUN_DIR/mysqld.sock"

# require_var() {
# 	if [ -z "$2" ]; then
# 		echo "[MariaDB] Error: $1 is not set"
# 		exit 1
# 	fi
# 	echo "[MariaDB] $1 is set"
# }

# require_var MYSQL_DATABASE "$MYSQL_DATABASE"
# require_var MYSQL_USER "$MYSQL_USER"
# require_var MYSQL_PASSWORD "$MYSQL_PASSWORD"

# mkdir -p "$RUN_DIR"
# chown -R mysql:mysql "$RUN_DIR"

# echo "[MariaDB] Starting temporary server"
# mysqld_safe --skip-networking --socket="$SOCKET" &

# until mysqladmin --socket="$SOCKET" ping >/dev/null 2>&1; do
# 	sleep 1
# done

# echo "[MariaDB] Configuring database"

# mysql --protocol=socket -S "$SOCKET" -u root <<-SQL
# 	CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
# 	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# 	GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
# 	FLUSH PRIVILEGES;
# SQL

# mysqladmin --socket="$SOCKET" -u root shutdown

# echo "[MariaDB] Starting final server"
# exec mysqld \
# 	--user=mysql \
# 	--bind-address=0.0.0.0 \
# 	--console
