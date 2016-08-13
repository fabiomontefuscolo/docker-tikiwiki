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

RUN curl -o tiki-wiki.tar.gz 'http://ufpr.dl.sourceforge.net/project/tikiwiki/Tiki_12.x_Altair/12.9/tiki-12.9.tar.gz' \
    && tar -C /var/www/html/ -zxvf  tiki-wiki.tar.gz --strip 1 \
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

RUN /bin/bash setup.sh insane

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
