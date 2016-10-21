<?php
    define('DB_USER',          getenv('DB_USER')          ?: 'wordpress');
    define('DB_NAME',          getenv('DB_NAME')          ?: 'wordpress');
    define('DB_PASSWORD',      getenv('DB_PASSWORD')      ?: 'wordpress');
    define('DB_HOST',          getenv('DB_HOST')          ?: 'mysql');
    define('DB_CHARSET',       getenv('DB_CHARSET')       ?: 'utf8');
    define('DB_COLLATE',       getenv('DB_COLLATE')       ?: '');

    define('AUTH_KEY',         getenv('AUTH_KEY')         ?: hash('sha256', DB_USER.DB_NAME.DB_PASSWORD.DB_HOST));
    define('SECURE_AUTH_KEY',  getenv('SECURE_AUTH_KEY')  ?: hash('sha256', AUTH_KEY));
    define('LOGGED_IN_KEY',    getenv('LOGGED_IN_KEY')    ?: hash('sha256', SECURE_AUTH_KEY));
    define('NONCE_KEY',        getenv('NONCE_KEY')        ?: hash('sha256', LOGGED_IN_KEY));
    define('AUTH_SALT',        getenv('AUTH_SALT')        ?: hash('sha256', NONCE_KEY));
    define('SECURE_AUTH_SALT', getenv('SECURE_AUTH_SALT') ?: hash('sha256', AUTH_SALT));
    define('LOGGED_IN_SALT',   getenv('LOGGED_IN_SALT')   ?: hash('sha256', SECURE_AUTH_SALT));
    define('NONCE_SALT',       getenv('NONCE_SALT')       ?: hash('sha256', LOGGED_IN_SALT));

    define('FS_METHOD',        getenv('FS_METHOD')        ?: 'direct');

    $table_prefix  =           getenv('TABLE_PREFIX')     ?: 'wp_';
    define('WP_DEBUG',         getenv('WP_DEBUG')         === 'true');
    define('WP_DEBUG_LOG',     getenv('WP_DEBUG_LOG')     === 'true');
    define('WP_DEBUG_DISPLAY', getenv('WP_DEBUG_DISPLAY') === 'true');

    if ( !defined('ABSPATH') )
        define('ABSPATH', dirname(__FILE__) . '/');

    if(getenv('HTTPS') === 'on') {
        $_SERVER['HTTPS'] = 'on';
    }

    if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false) {
      $_SERVER['HTTPS'] = 'on';
    }

    require_once(ABSPATH . 'wp-settings.php');
