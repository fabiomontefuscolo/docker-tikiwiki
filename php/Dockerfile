FROM php:5.6-apache
MAINTAINER Fabio Montefuscolo <fabio.montefuscolo@gmail.com>

RUN a2enmod rewrite expires ssl

# Install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libmemcached-dev && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mysqli opcache zip

# Support memcache
RUN printf "yes\n" | pecl install memcache \
    && echo 'extension=memcache.so' > /usr/local/etc/php/conf.d/pecl-memcache.ini

# Composer facility
RUN curl -s -o installer.php https://getcomposer.org/installer \
    && php installer.php --install-dir=/usr/local/bin/ --filename=composer \
    && rm installer.php

COPY docker-entrypoint.sh /entrypoint.sh

COPY localhost.key /etc/ssl/private/localhost.key
COPY localhost.crt /etc/ssl/certs/localhost.crt
COPY default-ssl.conf /etc/apache2/sites-enabled

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
