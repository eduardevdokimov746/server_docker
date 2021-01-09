FROM php:8-apache

EXPOSE 80:80

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

COPY custom.conf /etc/apache2/sites-available/custom.conf

RUN a2enmod rewrite \
    && a2ensite custom.conf

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN useradd -m edik
