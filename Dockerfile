FROM php:7.4.12-apache-buster

# Install debian dependencies
# libbz2-dev needed for php bz2 extension
# libcurl4-openssl-dev needed for php curl extension
# libxml2-dev needed for php dom extension
# libenchant-dev needed for php enchant extension
# libssl-dev needed for php ftp extension
# libpng-dev needed for php gd extension
# libgmp3-dev needed for php gmp extension
# libicu-dev needed for php intl extension
# libc-client-dev needed for php imap extension
# libkrb5-dev needed for php imap extension
# libldap2-dev needed for php ldap extension
# libonig-dev needed for php mbstring extension
# freetds-dev needed for php pdo_dblib extension
# libsybdb5 needed for php pdo_dblib extension
# firebird-dev needed for php pdo_firebird
# libpq-dev for pdo_pgsql
# libsqlite3-dev for pdo_sqlite
# libpspell-dev for pspell
# libedit-dev for readline
# libargon2-dev for standard
RUN apt-get update -y
RUN apt-get install -y \
    firebird-dev \
    freetds-dev \
    libargon2-dev \
    libbz2-dev \
    libc-client-dev \
    libcurl4-openssl-dev \
    libedit-dev \
    libenchant-dev \
    libgmp3-dev \
    libicu-dev \
    libkrb5-dev \
    libldap2-dev \
    libonig-dev \
    libpng-dev \
    libpq-dev \
    libpspell-dev \
    libsnmp-dev \
    libssl-dev \
    libsybdb5 \
    libsodium-dev \
    libsqlite3-dev \
    libtidy-dev \
    libxml2-dev \
    libxslt1-dev \
    libzip-dev

# Make symlink for pdo_dblib
# See https://stackoverflow.com/questions/43617752/docker-php-and-freetds-cannot-find-freetds-in-know-installation-directories
RUN ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib

# Configure extensions before installing
RUN docker-php-ext-configure \
    imap --with-kerberos --with-imap-ssl

# Install PHP dependencies
# TODO: hash
# TODO: oci8
# TODO: odbc
# TODO: pdo_oci
# TODO: pdo_odbc
# TODO: reflection
# TODO: spl
# TODO: standard
# TODO: xmlreader
RUN docker-php-ext-install \
    bcmath \
    bz2 \
    calendar \
    ctype \
    curl \
    dba \
    dom \
    enchant \
    exif \
    ffi \
    fileinfo \
    filter \
    ftp \
    gd \
    gettext \
    gmp \
    iconv \
    imap \
    intl \
    json \
    ldap \
    mbstring \
    mysqli \
    opcache \
    pcntl \
    pdo \
    pdo_dblib \
    pdo_firebird \
    pdo_mysql \
    pdo_pgsql \
    pdo_sqlite \
    pgsql \
    phar \
    posix \
    pspell \
    readline \
    session \
    shmop \
    simplexml \
    snmp \
    soap \
    sockets \
    sodium \
    sysvmsg \
    sysvsem \
    sysvshm \
    tidy \
    tokenizer \
    xml \
    xmlrpc \
    xmlwriter \
    xsl \
    zend_test \
    zip
