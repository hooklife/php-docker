
FROM alpine:3.11

ARG ALPINE_VERSION
ARG PHP_VERSION=7.4
ARG S6_OVERLAY_VERSION=3.1.0.1
ARG COMPOSER_VERSION=1

ENV S6_OVERLAY_VERSION=${S6_OVERLAY_VERSION} \
    TIME_ZONE=Asia/Shanghai \
    PHP_VERSION=${PHP_VERSION} \
    COMPOSER_VERSION=${COMPOSER_VERSION}

# trust this project public key to trust the packages.
ADD https://php.hernandev.com/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

##
# ---------- building ----------
##
RUN set -ex; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && addgroup -g 82 -S www-data \
    && adduser -u 82 -D -S -G www-data www-data\
    # change apk source repo
    && apk --update add ca-certificates bash tini \
    && echo "https://php.hernandev.com/v3.11/php-$PHP_VERSION" >> /etc/apk/repositories\
    && apk update \
    && apk add --no-cache \
    # # Install base packages ('ca-certificates' will install 'nghttp2-libs')
    # tar \
    curl \
    libressl \
    tzdata \
    pcre \
    php7 \
    php7-bcmath \
    php7-curl \
    php7-ctype \
    php7-dom \
    php7-gd \
    php7-iconv \
    php7-json \
    php7-mbstring \
    php7-mysqlnd \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-phar \
    php7-posix \
    php7-redis \
    php7-sockets \
    php7-sodium \
    php7-sysvshm \
    php7-sysvmsg \
    php7-sysvsem \
    php7-zip \
    php7-zlib \
    php7-xml \
    php7-xmlreader \
    php7-pcntl \
    php7-session \
    php7-opcache \
    php7-fpm \
    nginx \
    fcgi \
    # install composer
    && ln -sf /usr/bin/php7 /usr/bin/php \
    && curl -sS https://getcomposer.org/installer | php -- --${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer \
    # && composer --version \
    # timezone
    && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && echo "${TIME_ZONE}" > /etc/timezone \
    # delete apk
    && apk del curl tar tzdata\
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7 \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

COPY rootfs /


ENTRYPOINT ["/sbin/tini", "--", "/usr/sbin/entrypoint.sh"]