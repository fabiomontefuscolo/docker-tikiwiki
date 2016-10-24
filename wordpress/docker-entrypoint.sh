#!/bin/bash

keygen() {
    cat /dev/urandom | tr -dc '[:print:]' | tr "\\\\" "-" | tr "'" "-" | head -c64;
}

export AUTH_KEY="${AUTH_KEY:-$(keygen)}"
export SECURE_AUTH_KEY="${SECURE_AUTH_KEY:-$(keygen)}"
export LOGGED_IN_KEY="${LOGGED_IN_KEY:-$(keygen)}"
export NONCE_KEY="${NONCE_KEY:-$(keygen)}"
export AUTH_SALT="${AUTH_SALT:-$(keygen)}"
export SECURE_AUTH_SALT="${SECURE_AUTH_SALT:-$(keygen)}"
export LOGGED_IN_SALT="${LOGGED_IN_SALT:-$(keygen)}"
export NONCE_SALT="${NONCE_SALT:-$(keygen)}"


if [ "$WP_DEBUG" != "true" ] && [ "$OPCACHE" != "false" ];
then
    cat > /usr/local/etc/php/conf.d/opcache-recommended.ini << EOF
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.enable_cli=1
EOF
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

if [ -n "$uid" ] && [ "$WORDPRESS_WP_DEBUG" = "true" ];
then
    user=$(awk -F: "/:$uid:[0-9]+:/{ print \$1}" /etc/passwd)
    group=$(awk -F: "/:x:$gid:/{ print \$1}" /etc/group)

    if [ -z "$group" ];
    then
        usermod -g "$gid" www-data
    fi

    if [ -z "$user" ];
    then
        usermod -u "$uid" wordpress
    fi
else
    uid=$(awk -F: '/^www-data/{ print $3 }' /etc/passwd)
fi


for f in /docker-entrypoint-extra/*; do
    case "$f" in
        *.sh)     echo "$0: running $f"; . "$f" ;;
        *.php)    echo "$0: running $f"; "${PHP}" < "$f" ;;
        *)        echo "$0: ignoring $f" ;;
    esac
    echo
done

exec "$@"