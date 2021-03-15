FROM tiredofit/nginx-php-fpm:8.0
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Defaults
ENV FLARUM_VERSION=0.1.0-beta.16 \
    NGINX_UPLOAD_MAX_SIZE=2G \
    NGINX_WEBROOT="/www/flarum" \
    PHP_UPLOAD_MAX_SIZE=2G \
    PHP_TIMEOUT=900 \
    PHP_MEMORY_LIMIT=512m \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_FILEINFO=TRUE \
    PHP_ENABLE_TOKENIZER=TRUE \
    PHP_ENABLE_ZIP=TRUE \
    ZABBIX_HOSTNAME=flarum-app

### Perform Installation
RUN set -x && \
    apk update && \
    apk upgrade && \
    \
    ## Fetch Flarum
    #composer global require hirak/prestissimo && \
    mkdir -p ${NGINX_WEBROOT} && \
    chown -R ${NGINX_USER}:${NGINX_GROUP} ${NGINX_WEBROOT} && \
    mkdir -p /tmp/flarum && \
    COMPOSER_CACHE_DIR="/tmp" composer create-project flarum/flarum ${NGINX_WEBROOT} v$FLARUM_VERSION --stability=beta && \
    composer clear-cache && \
    \
    ## Data Persistence Setup
    mkdir /assets/install && \
    cp -R ${NGINX_WEBROOT}/public/assets /assets/install && \
    cp -R ${NGINX_WEBROOT}/storage /assets/install && \
    mkdir -p /assets/install/extensions && \
    rm -rf ${NGINX_WEBROOT}/public/assets && \
    rm -rf ${NGINX_WEBROOT}/storage && \
    ln -sf /data/assets ${NGINX_WEBROOT}/public/assets && \
    ln -sf /data/storage ${NGINX_WEBROOT}/storage && \
    ln -sf /data/extensions ${NGINX_WEBROOT}/extensions && \
    \
    ## Cleanup
    rm -rf /var/cache/apk/* /tmp/*

ENV COMPOSER_CACHE_DIR=${NGINX_WEBROOT}/extensions/.cache

ADD install /

