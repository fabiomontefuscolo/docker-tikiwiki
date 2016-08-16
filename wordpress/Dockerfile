FROM montefuscolo/php
MAINTAINER Fabio Montefuscolo <fabio.montefuscolo@gmail.com>

RUN curl -o wp-cli.phar 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar?0.23.1' \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN curl -o installer.php "https://getcomposer.org/installer" \
    && php installer.php --install-dir=/usr/local/bin/ --filename=composer \
    && rm installer.php

RUN wp core download --path=/var/www/html/ --version=4.5.3 --allow-root
RUN chown -R root:root /var/www/html/ \
    && chown -R www-data:www-data /var/www/html/wp-content

COPY htaccess /var/www/html/.htaccess
COPY wp-config.php /var/www/html/wp-config.php

RUN mkdir -p /docker-entrypoint-extra/
COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
