#!/bin/sh

set -e

DATADIR="/var/lib/mysql"
RUN_DIR="/run/mysqld"
SOCKET="$RUN_DIR/mysqld.sock"

# =========================
# Vérification variables
# =========================
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
require_var MYSQL_ROOT_PASSWORD "$MYSQL_ROOT_PASSWORD"

# =========================
# Préparation filesystem
# =========================
mkdir -p "$RUN_DIR"
chown -R mysql:mysql "$RUN_DIR" "$DATADIR"

# =========================
# Démarrage temporaire
# =========================
echo "[MariaDB] Starting temporary server"
mysqld_safe --skip-networking --socket="$SOCKET" &

# Attente MariaDB
until mysqladmin --socket="$SOCKET" ping >/dev/null 2>&1; do
	sleep 1
done

# =========================
# Init logique (idempotent)
# =========================
echo "[MariaDB] Configuring database"

mysql --socket="$SOCKET" -u root <<-SQL
	ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

	CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

	CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

	FLUSH PRIVILEGES;
SQL

# =========================
# Arrêt serveur temporaire
# =========================
mysqladmin --socket="$SOCKET" -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

# =========================
# Lancement final
# =========================
echo "[MariaDB] Starting final server"
exec mysqld \
	--user=mysql \
	--bind-address=0.0.0.0 \
	--console
