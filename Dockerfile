ARG PHP_VERSION="7.4.19"

FROM php:${PHP_VERSION}-apache-buster

ARG COMPOSER_VERSION="2.0.13"

RUN apt-get update -y

# Install underlying dependencies
# gd requres: libpng-dev, zlib1g-dev
RUN apt-get install -y \
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
    gd \
    intl \
    pdo_mysql

# Enable apache module for URL re-writing
RUN a2enmod rewrite headers

# Copy apache and php configs
COPY apache/000-default.conf /etc/apache2/sites-enabled
COPY apache/security.conf /etc/apache2/conf-available/security.conf
COPY php/php.ini /usr/local/etc/php/php.ini

# Add Cake command line tools to path
RUN echo "export PATH=/var/www/html/bin:$PATH" >> /root/.bashrc
