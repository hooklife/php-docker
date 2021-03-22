ARG BASE_IMAGE
FROM $BASE_IMAGE


RUN set -ex \
    && apk update \
    && apk del nginx\
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7 \
    && ln -s /etc/services.example/php-fpm /etc/services.d \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

