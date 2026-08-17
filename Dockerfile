# The following args need to be repeated after the FROM statement
ARG PHP_VERSION
ARG DEBIAN_VERSION
ARG SERVER

FROM php:${PHP_VERSION}-${SERVER}-${DEBIAN_VERSION}

# Repeatd from above because before FROM scope is not applied after FROM
ARG PHP_VERSION
ARG DEBIAN_VERSION
ARG SERVER

RUN apt-get update -y

# Install underlying dependencies
# gd requires: libpng-dev, zlib1g-dev
# curl requires: libcurl4-openssl-dev
RUN apt-get install -y \
    git \
    libcurl4-openssl-dev \
    libicu-dev \
    libpng-dev \
    unzip \
    zip \
    zlib1g-dev

# Install Composer
RUN curl -o /usr/local/bin/composer https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar
RUN chmod +x /usr/local/bin/composer

# Install PHP extensions
RUN docker-php-ext-install \
    bcmath \
    curl \
    gd \
    intl \
    pdo_mysql

# Enable apache module for URL re-writing
# Configure apache security module
RUN if [ "$SERVER" = "apache" ]; then \
    a2enmod rewrite headers && \
    a2enconf security; \
fi

# Copy php configs
COPY php/php.ini /usr/local/etc/php/php.ini

# Copy apache configs (unused by fpm)
COPY apache/000-default.conf /etc/apache2/sites-enabled
COPY apache/security.conf /etc/apache2/conf-available/security.conf
