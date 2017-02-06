FROM montefuscolo/php
MAINTAINER Fabio Montefuscolo <fabio.montefuscolo@gmail.com>

WORKDIR /var/www/html/

RUN curl -o tiki-wiki.tar.gz 'http://ufpr.dl.sourceforge.net/project/tikiwiki/Tiki_16.x_Tabbys/16.2/tiki-16.2.tar.gz' \
    && tar -C /var/www/html -zxvf  tiki-wiki.tar.gz --strip 1 \
    && rm tiki-wiki.tar.gz \
    && { \
        echo "<?php"; \
        echo "    \$db_tiki        = getenv('TIKI_DB_DRIVER') ?: 'mysql';"; \
        echo "    \$dbversion_tiki = getenv('TIKI_DB_VERSION') ?: '16.2';"; \
        echo "    \$host_tiki      = getenv('TIKI_DB_HOST') ?: 'db';"; \
        echo "    \$user_tiki      = getenv('TIKI_DB_USER');"; \
        echo "    \$pass_tiki      = getenv('TIKI_DB_PASS');"; \
        echo "    \$dbs_tiki       = getenv('TIKI_DB_NAME') ?: 'tikiwiki';"; \
        echo "    \$client_charset = 'utf8';"; \
    } > /var/www/html/db/local.php \
    && /bin/bash htaccess.sh \
    && chown -R root:root /var \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && chown -R www-data /var/www/html/db/ \
    && chown -R www-data /var/www/html/dump/ \
    && chown -R www-data /var/www/html/img/trackers/ \
    && chown -R www-data /var/www/html/img/wiki/ \
    && chown -R www-data /var/www/html/img/wiki_up/ \
    && chown -R www-data /var/www/html/modules/cache/ \
    && chown -R www-data /var/www/html/temp/ \
    && chown -R www-data /var/www/html/temp/cache/ \
    && chown -R www-data /var/www/html/templates/ \
    && chown -R www-data /var/www/html/templates_c/ \
    && chown -R www-data /var/www/html/whelp/


COPY entrypoint.sh /entrypoint.sh
VOLUME ["/var/www/html/files/", "/var/www/html/img/wiki/", "/var/www/html/img/wiki_up/", "/var/www/html/img/trackers/"]

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
