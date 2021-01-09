FROM php:8-apache

EXPOSE 80:80

RUN docker-php-ext-install pdo pdo_mysql

COPY custom.conf /etc/apache2/sites-available/custom.conf

RUN a2enmod rewrite \
    && a2ensite custom.conf

RUN useradd -m edik

