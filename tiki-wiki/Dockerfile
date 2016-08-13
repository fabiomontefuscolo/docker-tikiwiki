FROM montefuscolo/php
MAINTAINER Fabio Montefuscolo <fabio.montefuscolo@gmail.com>

RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN curl -o tiki-wiki.tar.gz 'http://ufpr.dl.sourceforge.net/project/tikiwiki/Tiki_12.x_Altair/12.9/tiki-12.9.tar.gz'
RUN tar -C /var/www/html -zxvf  tiki-wiki.tar.gz --strip 1 \
    && rm tiki-wiki.tar.gz

WORKDIR /var/www/html/

RUN { \
        echo "<?php"; \
        echo "    \$db_tiki        = getenv('TIKI_DB_DRIVER') ?: 'mysql';"; \
        echo "    \$dbversion_tiki = getenv('TIKI_DB_VERSION') ?: '12.9';"; \
        echo "    \$host_tiki      = getenv('TIKI_DB_HOST') ?: 'db';"; \
        echo "    \$user_tiki      = getenv('TIKI_DB_USER');"; \
        echo "    \$pass_tiki      = getenv('TIKI_DB_PASS');"; \
        echo "    \$dbs_tiki       = getenv('TIKI_DB_NAME') ?: 'tikiwiki';"; \
        echo "    \$client_charset = 'utf8';"; \
    } > db/local.php

RUN /bin/bash htaccess.sh
RUN chown -R root:root /var \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && chown -R www-data db \
    && chown -R www-data dump \
    && chown -R www-data img/wiki \
    && chown -R www-data img/wiki_up \
    && chown -R www-data img/trackers \
    && chown -R www-data modules/cache \
    && chown -R www-data temp \
    && chown -R www-data temp/cache \
    && chown -R www-data templates_c \
    && chown -R www-data whelp

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ['/tmp']

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
