FROM alpine/git AS downloader
RUN mkdir -p /var/www \
    && git clone --depth 1 --branch=17.x https://gitlab.com/tikiwiki/tiki.git /var/www/html


FROM tikiwiki/php:5-apache
LABEL mantainer "TikiWiki <tikiwiki-devel@lists.sourceforge.net>"

COPY --from=downloader /var/www/html /var/www/html
WORKDIR "/var/www/html"

RUN composer global require hirak/prestissimo \
    && composer install --working-dir /var/www/html/vendor_bundled --prefer-dist \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /root/.composer \
    && { \
        echo "<?php"; \
        echo "    \$db_tiki        = getenv('TIKI_DB_DRIVER') ?: 'mysqli';"; \
        echo "    \$dbversion_tiki = getenv('TIKI_DB_VERSION') ?: '17';"; \
        echo "    \$host_tiki      = getenv('TIKI_DB_HOST') ?: 'db';"; \
        echo "    \$user_tiki      = getenv('TIKI_DB_USER');"; \
        echo "    \$pass_tiki      = getenv('TIKI_DB_PASS');"; \
        echo "    \$dbs_tiki       = getenv('TIKI_DB_NAME') ?: 'tikiwiki';"; \
        echo "    \$client_charset = 'utf8mb4';"; \
    } > /var/www/html/db/local.php \
    && {\
        echo "session.save_path=/var/www/sessions"; \
    }  > /usr/local/etc/php/conf.d/tiki_session.ini \
    && /bin/bash htaccess.sh \
    && mkdir -p /var/www/sessions \
    && chown -R www-data /var/www/sessions \
    && chown -R www-data /var/www/html/db/ \
    && chown -R www-data /var/www/html/dump/ \
    && chown -R www-data /var/www/html/img/trackers/ \
    && chown -R www-data /var/www/html/img/wiki/ \
    && chown -R www-data /var/www/html/img/wiki_up/ \
    && chown -R www-data /var/www/html/modules/cache/ \
    && chown -R www-data /var/www/html/temp/ \
    && chown -R www-data /var/www/html/templates/

VOLUME ["/var/www/html/files/","/var/www/html/img/trackers/","/var/www/html/img/wiki_up/","/var/www/html/img/wiki/","/var/www/html/modules/cache/","/var/www/html/storage/","/var/www/html/temp/","/var/www/sessions/"]
EXPOSE 80
CMD ["apache2-foreground"]
