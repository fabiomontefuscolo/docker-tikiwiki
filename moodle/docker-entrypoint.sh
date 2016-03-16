#!/bin/bash
if [ "$OPCACHE" = "disable" ];
then
    if [ -e "/var/www/html/.htaccess" ];
    then
        sed -i -e '/^ *php_flag \+opcache.enable/d' /var/www/html/.htaccess
    fi

    echo "php_flag opcache.enable Off" >> /var/www/html/.htaccess
fi

exec "$@"