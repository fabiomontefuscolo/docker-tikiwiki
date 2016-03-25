#!/bin/bash

keygen() {
    cat /dev/urandom | tr -dc '[:print:]' | tr "\\\\" "-" | tr "'" "-" | head -c64;
}

DB_USER="${WORDPRESS_DB_USER:=${MYSQL_ENV_MYSQL_USER:-root}}";
DB_NAME="${WORDPRESS_DB_NAME:=${MYSQL_ENV_MYSQL_DATABASE:-wordpress}}";
DB_PASSWORD="${WORDPRESS_DB_PASSWORD:=${MYSQL_ENV_MYSQL_PASSWORD:$MYSQL_ENV_MYSQL_ROOT_PASSWORD}}";
DB_HOST="${WORDPRESS_DB_HOST:-mysql}";

#
# Create wp-config.php
#
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

#
# Create .htaccess
#
if ! [ -e "/var/www/html/.htaccess" ];
then
    cat > /var/www/html/.htaccess << EOF
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
EOF

    if [ "$WORDPRESS_WP_DEBUG" = "true" ];
    then
        echo "php_flag opcache.enable Off" >> /var/www/html/.htaccess
    fi
fi


#
# Should I respect the owner of mounted volumes
#
volume=$(mount -l | awk '/var\/www\/html/{ print $3; exit; }')
if [ -n "$volume" ];
then
    uid=$(stat -c %u "$volume")
    gid=$(stat -c %g "$volume")
fi

if [ -n "$uid" ];
then
    user=$(awk -F: "/:$uid:[0-9]+:/{ print \$1}" /etc/passwd)
    group=$(awk -F: "/:x:$gid:/{ print \$1}" /etc/group)

    if [ -z "$group" ];
    then
        usermod -g "$gid" www-data
    fi

    if [ -z "$user" ];
    then
        usermod -u "$uid" www-data
    fi
fi

chown www-data:www-data /var/www/html/.htaccess
chown www-data:www-data /var/www/html/wp-config.php
chown -R www-data:www-data /var/www/html/wp-content


#
# Setup database and user
#
php << EOF
<?php
    \$con = @new mysqli($DB_HOST, 'root', '$MYSQL_ENV_MYSQL_ROOT_PASSWORD');
    if(\$con->connect_errno === 0) {
        \$con->query("create database if not exists '$DB_NAME'");
        \$con->query("grant all privileges on \`$DB_NAME\`.* to '$DB_USER'@'%' identified by '$DB_PASSWORD'");
        \$con->query("flush privileges");
    }
EOF

exec "$@"