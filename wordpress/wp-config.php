<?php
    define('DB_USER',     getenv('DB_USER')              ?: 'wordpress');
    define('DB_NAME',     getenv('DB_NAME')              ?: 'wordpress');
    define('DB_PASSWORD', getenv('DB_PASSWORD')          ?: 'wordpress');
    define('DB_HOST',     getenv('DB_HOST')              ?: 'mysql');
    define('DB_CHARSET',  getenv('WORDPRESS_DB_CHARSET') ?: 'utf8');
    define('DB_COLLATE',  getenv('WORDPRESS_DB_COLLATE') ?: '');

    define('AUTH_KEY',         getenv('WORDPRESS_AUTH_KEY')         ?: 'secret');
    define('SECURE_AUTH_KEY',  getenv('WORDPRESS_SECURE_AUTH_KEY')  ?: 'secret');
    define('LOGGED_IN_KEY',    getenv('WORDPRESS_LOGGED_IN_KEY')    ?: 'secret');
    define('NONCE_KEY',        getenv('WORDPRESS_NONCE_KEY')        ?: 'secret');
    define('AUTH_SALT',        getenv('WORDPRESS_AUTH_SALT')        ?: 'secret');
    define('SECURE_AUTH_SALT', getenv('WORDPRESS_SECURE_AUTH_SALT') ?: 'secret');
    define('LOGGED_IN_SALT',   getenv('WORDPRESS_LOGGED_IN_SALT')   ?: 'secret');
    define('NONCE_SALT',       getenv('WORDPRESS_NONCE_SALT')       ?: 'secret');

    $table_prefix  = getenv('WORDPRESS_TABLE_PREFIX') ?: 'wp_';
    define('WP_DEBUG', getenv('WORDPRESS_WP_DEBUG') === 'true');
    define('WP_DEBUG_LOG', getenv('WORDPRESS_WP_DEBUG_LOG') === 'true');
    define('WP_DEBUG_DISPLAY', getenv('WORDPRESS_WP_DEBUG_DISPLAY') === 'true');

    if ( !defined('ABSPATH') )
        define('ABSPATH', dirname(__FILE__) . '/');

    require_once(ABSPATH . 'wp-settings.php');