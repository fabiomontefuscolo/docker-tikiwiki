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
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mysqli opcache

COPY docker-entrypoint.sh /entrypoint.sh

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout localhost.key -out localhost.crt \
        -subj "/C=BR/ST=SP/L=São Roque/O=Hacklab/OU=Development/CN=Dev/emailAddress=a@b.cd" \
    && mv localhost.key /etc/ssl/private/localhost.key \
    && mv localhost.crt /etc/ssl/certs/localhost.crt
COPY default-ssl.conf /etc/apache2/sites-enabled

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
