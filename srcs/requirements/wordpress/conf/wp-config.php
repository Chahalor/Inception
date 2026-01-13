<?php

define('DB_NAME', getenv('MYSQL_DATABASE'));
define('DB_USER', getenv('MYSQL_USER'));
define('DB_PASSWORD', getenv('MYSQL_PASSWORD'));
define('DB_HOST', getenv('DB_HOST'));

define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('WP_HOME', 'http://nduvoid.42.fr');
define('WP_SITEURL', 'http://nduvoid.42.fr');

$table_prefix = 'wp_';

define('WP_DEBUG', false);

if ( ! defined('ABSPATH') ) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
