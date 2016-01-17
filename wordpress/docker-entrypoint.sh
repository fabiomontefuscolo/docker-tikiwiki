#!/bin/bash

keygen() {
    cat /dev/urandom | tr -dc '[:print:'] | tr "\\\\" "-" | tr "'" "-" | head -c64;
}

DB_USER="${WORDPRESS_DB_USER:=${MYSQL_ENV_MYSQL_USER:-root}}";
DB_NAME="${WORDPRESS_DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-wordpress}}";
DB_PASSWORD="${WORDPRESS_DB_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}";
DB_HOST="${WORDPRESS_DB_HOST:-mysql}";

# create wp-config.php
if ! [ -e "/var/www/html/wp-config.php" ];
then
    cat > /var/www/html/wp-config.php << EOF
<?php
    define('DB_USER',     '$DB_USER');
    define('DB_NAME',     '$DB_NAME');
    define('DB_PASSWORD', '$DB_PASSWORD');
    define('DB_HOST',     '$DB_HOST');
    define('DB_CHARSET',  '${WORDPRESS_DB_CHARSET:-utf8}');
    define('DB_COLLATE',  '${WORDPRESS_DB_COLLATE}');

    define('AUTH_KEY',         '${WORDPRESS_AUTH_KEY:-$(keygen)}');
    define('SECURE_AUTH_KEY',  '${WORDPRESS_SECURE_AUTH_KEY:-$(keygen)}');
    define('LOGGED_IN_KEY',    '${WORDPRESS_LOGGED_IN_KEY:-$(keygen)}');
    define('NONCE_KEY',        '${WORDPRESS_NONCE_KEY:-$(keygen)}');
    define('AUTH_SALT',        '${WORDPRESS_AUTH_SALT:-$(keygen)}');
    define('SECURE_AUTH_SALT', '${WORDPRESS_SECURE_AUTH_SALT:-$(keygen)}');
    define('LOGGED_IN_SALT',   '${WORDPRESS_LOGGED_IN_SALT:-$(keygen)}');
    define('NONCE_SALT',       '${WORDPRESS_NONCE_SALT:-$(keygen)}');

    \$table_prefix  = '${WORDPRESS_TABLE_PREFIX:-wp}_';
    define('WP_DEBUG', ${WORDPRESS_WP_DEBUG:-false});

    if ( !defined('ABSPATH') )
        define('ABSPATH', dirname(__FILE__) . '/');
    require_once(ABSPATH . 'wp-settings.php');
EOF
fi

# create database if not exists
php -r "(new mysqli('$DB_HOST', '$DB_USER', '$DB_PASSWORD'))->query('create database if not exists $DB_NAME');"

exec "$@"