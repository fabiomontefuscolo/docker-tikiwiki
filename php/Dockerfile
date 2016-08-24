FROM php:5.6-apache
MAINTAINER Fabio Montefuscolo <fabio.montefuscolo@gmail.com>
#
# It is based on official Wordpress Dockerfile, but I put
# files direct on /var/www/html instead /usr/src/wordpress.
# You can mount your wp-content, wp-config.php and .htaccess
# and the entrypoint script will not overwrte your files.
# It helps me on theme and plugin development.
#
RUN a2enmod rewrite expires ssl

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libmemcached-dev && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mysqli opcache zip \
    && printf "\n" | pecl install memcached \
    && curl -o installer.php https://getcomposer.org/installer \
    && php installer.php \
    && php installer.php \
    && rm installer.php \
    && mv composer.phar /usr/local/bin/composer

COPY docker-entrypoint.sh /entrypoint.sh

COPY localhost.key /etc/ssl/private/localhost.key
COPY localhost.crt /etc/ssl/certs/localhost.crt
COPY default-ssl.conf /etc/apache2/sites-enabled

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
