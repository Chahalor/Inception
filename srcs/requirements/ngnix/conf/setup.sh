#!/bin/bash
set -e

echo "Starting nginx. Trying not to overthink it."

# Ensure runtime directories exist
mkdir -p /run/nginx
mkdir -p /var/www/html

# Optional: permissions if you mount volumes
chown -R www-data:www-data /var/www/html

# Test config before starting (this saves lives)
nginx -t

# Start nginx in foreground (Docker requirement)
exec nginx -g "daemon off;"
