FROM php:7.2-apache
# Install necessary extensions
RUN apt-get update && apt-get install -y \
        libicu-dev \
        libpq-dev \
        mariadb-client \
        curl \
        wget \
        git \
        zip \
        unzip \
        libzip-dev \
        zlib1g-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libmagickwand-dev \
        memcached \
    && export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick-3.4.4 \
    && docker-php-ext-enable imagick \
    && pecl install mcrypt-1.0.2 \
    && docker-php-ext-enable mcrypt \
    && docker-php-ext-install -j$(nproc) mysqli \
        intl \
        bcmath \
        pcntl \
        mbstring \
        exif \
        mysqli \
        opcache \
        zip \
        pdo \
        pdo_mysql \
        iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php \
    && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer

# Install WP-CLI
RUN cd /opt \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN chown www-data:www-data /var/www/html/ -R


ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_PID_FILE  /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2
ENV APACHE_LOCK_DIR  /var/lock/apache2
ENV APACHE_LOG_DIR   /var/log/apache2

RUN mkdir -p $APACHE_RUN_DIR
RUN mkdir -p $APACHE_LOCK_DIR
RUN mkdir -p $APACHE_LOG_DIR

# Install docker-entrypoint
RUN git clone https://github.com/dewa55/inpure /tmp/in
RUN mv /tmp/in/config/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
#RUN wget https://github.com/dewa55/inpure/blob/main/config/docker-entrypoint.sh -O /docker-entrypoint.sh
# Install php.ini
RUN mv /tmp/in/config/php/php.ini /usr/local/etc/php/conf.d/local.ini
RUN chmod 777 /usr/local/etc/php/conf.d/local.ini
# Install vhosts
RUN mv /tmp/in/config/vhosts/default.conf /etc/apache2/sites-enabled
RUN chmod 777 /etc/apache2/sites-enabled/*
# Install apps
RUN  git -C /var/www/html clone https://github.com/dewa55/apps
RUN mv /var/www/html/apps/app1 /var/www/html/
RUN mv /var/www/html/apps/app2 /var/www/html/
RUN mv /var/www/html/apps/app3 /var/www/html/
RUN chmod 777 /var/www/html/*

WORKDIR /var/www/html/

CMD ["/bin/bash","/docker-entrypoint.sh"]
