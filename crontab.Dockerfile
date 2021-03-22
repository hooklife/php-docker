ARG BASE_IMAGE
FROM $BASE_IMAGE


ENV ENABLE_CRONTAB=1
RUN set -ex \
    && apk update \
    && apk del php7-fpm nginx\
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7 \
    && ln -s /etc/services.example/crontab /etc/services.d \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"
