FROM php:fpm

RUN apt-get update && apt-get install -y \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
#   libzmq3-dev \
    nano \
# GD
    libwebp-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxpm-dev \
    libfreetype6-dev

RUN apt-get install -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
# GD
RUN docker-php-ext-configure gd --with-webp --with-jpeg --with-xpm --with-freetype

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl pdo_pgsql pgsql
#COPY custom.conf /etc/apache2/sites-available/custom.conf

#ADD php-zmq /usr/local/php-zmq

#RUN cd /usr/local/php-zmq \
#    && phpize \
#    && ./configure \
#    && make --silent \
#    && make install \
#    && echo "extension=zmq.so" >> `php --ini | grep "Loaded Configuration" | sed -e #"s|.*:\s*||"` \
#    && cd .. \
#    && rm -r php-zmq

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN useradd -m edik
