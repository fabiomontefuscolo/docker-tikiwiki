#!/bin/bash

if [ "$OPCACHE" = "false" ];
then
    echo "php_flag opcache.enable Off" >> /var/www/html/.htaccess
fi

exec "$@"