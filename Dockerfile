ARG PHP_VERSION="7.4.13"

FROM php:${PHP_VERSION}-apache-buster

ARG COMPOSER_VERSION="2.0.8"

RUN apt-get update -y

# Install underlying dependencies
RUN apt-get install -y \
    libicu-dev \
    unzip \
    zip

# Install Composer
RUN curl -o /usr/local/bin/composer https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar
RUN chmod +x /usr/local/bin/composer

# Install PHP extensions
RUN docker-php-ext-install \
    intl \
    pdo_mysql

# Enable apache module for URL re-writing
RUN a2enmod rewrite
