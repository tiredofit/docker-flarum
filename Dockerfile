FROM docker.io/tiredofit/nginx-php-fpm:8.3-alpine
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV FLARUM_VERSION=1.8.1 \
    NGINX_UPLOAD_MAX_SIZE=2G \
    NGINX_SITE_ENABLED=flarum \
    NGINX_WEBROOT="/www/flarum" \
    PHP_UPLOAD_MAX_SIZE=2G \
    PHP_TIMEOUT=900 \
    PHP_MEMORY_LIMIT=512m \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_FILEINFO=TRUE \
    PHP_ENABLE_TOKENIZER=TRUE \
    PHP_ENABLE_ZIP=TRUE \
    IMAGE_NAME="tiredofit/flarum" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-flarum/"

RUN echo "" && \
    source /assets/functions/00-container && \
    set -x && \
    package update && \
    package upgrade && \
    mkdir -p "${NGINX_WEBROOT}" && \
    chown -R "${NGINX_USER}":"${NGINX_GROUP}" "${NGINX_WEBROOT}" && \
    mkdir -p /tmp/flarum && \
    COMPOSER_CACHE_DIR="/tmp/flarum" \
        composer create-project \
            flarum/flarum \
                "${NGINX_WEBROOT}" \
                    v"${FLARUM_VERSION}" \
                        --stability=beta && \
    composer clear-cache && \
    \
    mkdir /assets/install && \
    cp -R ${NGINX_WEBROOT}/public/assets /assets/install && \
    cp -R ${NGINX_WEBROOT}/storage /assets/install && \
    mkdir -p /assets/install/extensions && \
    rm -rf ${NGINX_WEBROOT}/public/assets && \
    rm -rf ${NGINX_WEBROOT}/storage && \
    ln -sf /data/assets ${NGINX_WEBROOT}/public/assets && \
    ln -sf /data/storage ${NGINX_WEBROOT}/storage && \
    ln -sf /data/extensions ${NGINX_WEBROOT}/extensions && \
    chown -R "${NGINX_USER}":"${NGINX_GROUP}" "${NGINX_WEBROOT}" && \
    package cleanup && \
    rm -rf \
            /tmp/*

ENV COMPOSER_CACHE_DIR=${NGINX_WEBROOT}/extensions/.cache

COPY install /

