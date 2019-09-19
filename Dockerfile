FROM registry.selfdesign.org/docker/nginx-php-fpm/7.3:latest
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Defaults
ENV FLARUM_VERSION=0.1.0-beta.10 \
    UPLOAD_MAX_SIZE=2G \
    PHP_TIMEOUT=900 \
    PHP_MEMORY_LIMIT=512m \
    ZABBIX_HOSTNAME=flarum-app

### Perform Installation
RUN set -x && \
    apk update && \
    apk upgrade && \
    \
    # PHP Hack to allow for composer to run upon build
    mv /etc/php7/php-fpm.conf /etc/php7/php-fpm.confx && \
    mv /etc/php7/php.ini /etc/php7/php.inix && \
    mv /etc/php7/conf.d/00_opcache.ini /etc/php7/conf.d/00_opcache.inix && \
    \
    ## Fetch Flarum
    composer global require hirak/prestissimo && \
    mkdir -p /www/html && \
    chown -R nginx:www-data /www/html && \
    COMPOSER_CACHE_DIR="/tmp" composer create-project flarum/flarum /www/html v$FLARUM_VERSION --stability=beta && \
    composer clear-cache && \
    touch /www/html/index.php
    \
    ## Data Persistence Setup
RUN    mkdir /assets/install && \
    cp -R /www/html/public/assets /assets/install && \
    cp -R /www/html/storage /assets/install && \
    mkdir -p /assets/install/extensions && \
    rm -rf /www/html/public/assets && \
    rm -rf /www/html/storage && \
    ln -s /data/assets /www/html/public/assets && \
    ln -s /data/storage /www/html/storage && \
    ln -s /data/extensions /www/html/extensions && \
    \
    # Revert PHP Hack to allow for composer to run upon build
    mv /etc/php7/php-fpm.confx /etc/php7/php-fpm.conf && \
    mv /etc/php7/php.inix /etc/php7/php.ini && \
    mv /etc/php7/conf.d/00_opcache.inix /etc/php7/conf.d/00_opcache.ini && \
    \
    ## Cleanup
    rm -rf /var/cache/apk/* /tmp/*

ADD install /

