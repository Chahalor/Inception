#!/bin/bash
set -e

echo "Starting nginx. Trying not to overthink it."

# Ensure runtime directories exist
mkdir -p /run/nginx
mkdir -p /var/www/html
mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx.key \
	-out /etc/ssl/certs/nginx.crt \
	-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=eschwart.42.fr"

# Optional: permissions if you mount volumes
chown -R www-data:www-data /var/www/html

# Test config before starting (this saves lives)
nginx -t

# Start nginx in foreground (Docker requirement)
exec nginx -g "daemon off;"
