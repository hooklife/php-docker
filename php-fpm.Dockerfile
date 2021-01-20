ARG ALPINE_VERSION
FROM alpine:$ALPINE_VERSION

ARG ALPINE_VERSION
ARG PHP_VERSION=7.4
ARG S6_OVERLAY_VERSION=2.1.0.2
ARG COMPOSER_VERSION=1

ENV S6_OVERLAY_VERSION=${S6_OVERLAY_VERSION} \
    TIME_ZONE=Asia/Shanghai \
    PHP_VERSION=${PHP_VERSION} \
    COMPOSER_VERSION=${COMPOSER_VERSION}

# trust this project public key to trust the packages.
ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

##
# ---------- building ----------
##
RUN set -ex; \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && addgroup -g 1000 -S www-data  \
    && adduser -u 1000 -s /bin/sh -D -S -G www-data www-data \
    # change apk source repo
    && apk --update add ca-certificates \
    && echo "https://dl.bintray.com/php-alpine/v$ALPINE_VERSION/php-$PHP_VERSION" >> /etc/apk/repositories\
    && apk update \
    && apk add --no-cache \
    # Install base packages ('ca-certificates' will install 'nghttp2-libs')
    tar \
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
    # install composer
    && ln -sf /usr/bin/php7 /usr/bin/php \
    && curl -sS https://getcomposer.org/installer | php -- --${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer \
    && composer --version \
    #  install s6 overlay
    && curl -sSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar xfz - -C / \
    # timezone
    && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && echo "${TIME_ZONE}" > /etc/timezone \
    # delete apk
    && apk del curl tar tzdata\
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7 \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

COPY rootfs /

ENTRYPOINT ["/init"]