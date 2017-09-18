#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

FROM php:fpm

MAINTAINER Cheney Veron <cheneyveron@live.cn>

RUN mkdir -p /var/www
VOLUME /var/www

#
#--------------------------------------------------------------------------
# Software's Installation
#--------------------------------------------------------------------------
#
# Installing tools and PHP extentions using "apt", "docker-php", "pecl",
#

# Install "curl", "libmemcached-dev", "libpq-dev", "libjpeg-dev",
#         "libpng12-dev", "libfreetype6-dev", "libssl-dev", "libmcrypt-dev",
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libmemcached-dev \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng12-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev

# Install general utilities
RUN apt-get update \
	&& apt-get install -y \
		vim \
		net-tools \
		procps \
		telnet \
		netcat \
	&& rm -r /var/lib/apt/lists/*

# Install utilities used by TYPO3 CMS / Flow / Neos
RUN apt-get update \
	&& apt-get install -y \
		imagemagick \
		graphicsmagick \
		zip \
		unzip \
		wget \
		curl \
		git \
		mysql-client \
		moreutils \
		dnsutils \
	&& rm -rf /var/lib/apt/lists/*

# Install the PHP mcrypt extention
RUN docker-php-ext-install mcrypt

# Install the PHP pdo_mysql extention
RUN docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql
# Install the PHP pdo_pgsql extention
RUN docker-php-ext-install pdo_pgsql

# opcache
RUN docker-php-ext-install opcache

# zip
RUN docker-php-ext-install zip

#####################################
# gd:
#####################################

# Install the PHP gd library
RUN docker-php-ext-install gd && \
    docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd