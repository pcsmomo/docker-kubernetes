FROM php:7.4-fpm-alpine

WORKDIR /var/www/html

COPY src .

RUN docker-php-ext-install pdo pdo_mysql

RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

USER laravel

# RUN chown -R laravel:laravel .

# www-data is the default user:group created by php:7.4-fpm-alpine image
# RUN chown -R www-data:www-data /var/www/html