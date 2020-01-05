FROM tiredofit/nginx-php-fpm:7.3
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Defaults
ENV FLARUM_VERSION=0.1.0-beta.11 \
    NGINX_UPLOAD_MAX_SIZE=2G \
    PHP_UPLOAD_MAX_SIZE=2G \
    PHP_TIMEOUT=900 \
    PHP_MEMORY_LIMIT=512m \
    NGINX_WEBROOT="/www/flarum" \
    ZABBIX_HOSTNAME=flarum-app

### Perform Installation
RUN set -x && \
    apk update && \
    apk upgrade && \
    \
    ## Fetch Flarum
    composer global require hirak/prestissimo && \
    mkdir -p /www/html && \
    chown -R nginx:www-data /www/html && \
    mkdir -p /tmp/flarum && \
    mv /etc/php7/conf.d/*diseval* /tmp/flarum && \
    COMPOSER_CACHE_DIR="/tmp" composer create-project flarum/flarum /www/html v$FLARUM_VERSION --stability=beta && \
    composer clear-cache && \
    mv /tmp/flarum/* /etc/php7/conf.d/ && \
    touch /www/html/index.php && \
    \
    ## Data Persistence Setup
    mkdir /assets/install && \
    cp -R /www/html/public/assets /assets/install && \
    cp -R /www/html/storage /assets/install && \
    mkdir -p /assets/install/extensions && \
    rm -rf /www/html/public/assets && \
    rm -rf /www/html/storage && \
    ln -s /data/assets /www/html/public/assets && \
    ln -s /data/storage /www/html/storage && \
    ln -s /data/extensions /www/html/extensions && \
    \
    ## Cleanup
    rm -rf /var/cache/apk/* /tmp/*

ENV COMPOSER_CACHE_DIR=/www/html/extensions/.cache

ADD install /

