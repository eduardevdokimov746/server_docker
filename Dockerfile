FROM php:8-apache

EXPOSE 80:80
EXPOSE 5555:5555

RUN apt-get update && apt-get install -y \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
#   libzmq3-dev \
    nano

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl

COPY custom.conf /etc/apache2/sites-available/custom.conf

#ADD php-zmq /usr/local/php-zmq

#RUN cd /usr/local/php-zmq \
#    && phpize \
#    && ./configure \
#    && make --silent \
#    && make install \
#    && echo "extension=zmq.so" >> `php --ini | grep "Loaded Configuration" | sed -e #"s|.*:\s*||"` \
#    && cd .. \
#    && rm -r php-zmq

RUN a2enmod rewrite \
    && a2ensite custom.conf

COPY --from=composer:1.10 /usr/bin/composer /usr/bin/composer

RUN useradd -m edik
