FROM montefuscolo/php
MAINTAINER Fabio Montefuscolo <fabio.montefuscolo@gmail.com>

RUN curl -o wp-cli.phar 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar?0.24.1' \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN wp core download --path=/var/www/html/  --version=4.6 --locale=pt_BR --allow-root

COPY htaccess /var/www/html/.htaccess
COPY wp-config.php /var/www/html/wp-config.php

RUN useradd --no-create-home --no-user-group --groups www-data wordpress
RUN chown -R wordpress:root /var/www/html/ \
    && chown -R wordpress:www-data /var/www/html/wp-content \
    && find /var/www/html/wp-content -type d -exec chmod 775 {} \; \
    && find /var/www/html/wp-content -type f -exec chmod 664 {} \;

RUN mkdir -p /docker-entrypoint-extra/
COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
