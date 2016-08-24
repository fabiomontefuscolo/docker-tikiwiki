FROM php:5.6-apache
MAINTAINER Fabio Montefuscolo <fabio.montefuscolo@gmail.com>

RUN a2enmod rewrite expires ssl

# install the PHP extensions we need
RUN apt-get update \
    && apt-get install -y libpng12-dev libjpeg-dev libcurl3-dev libicu-dev libxml2-dev unzip \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mysqli opcache curl zip intl xmlrpc mbstring soap


# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=60'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN curl -o /tmp/moodle-2.7.zip 'https://download.moodle.org/download.php/direct/stable27/moodle-2.7.13.zip' \
    && rm -Rf /var/www/html/ \
    && mkdir -p /var/www/ \
    && unzip -d /var/www/ /tmp/moodle-2.7.zip \
    && rm /tmp/moodle-2.7.zip \
    && mv /var/www/moodle /var/www/html \
    && mkdir -p /var/www/moodledata \
    && chown -R www-data /var/www/moodledata

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout localhost.key -out localhost.crt \
        -subj "/C=BR/ST=SP/L=São Roque/O=Hacklab/OU=Development/CN=Dev/emailAddress=a@b.cd" \
    && mv localhost.key /etc/ssl/private/localhost.key \
    && mv localhost.crt /etc/ssl/certs/localhost.crt

COPY moodle-config.php /var/www/html/config.php
COPY docker-entrypoint.sh /entrypoint.sh
COPY default-ssl.conf /etc/apache2/sites-enabled

EXPOSE 80 443
VOLUME ["/var/www/moodledata", "/var/www/html/local"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
