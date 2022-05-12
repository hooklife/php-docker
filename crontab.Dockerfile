ARG BASE_IMAGE
FROM $BASE_IMAGE


ENV ENABLE_CRONTAB=1
RUN set -ex \
    && apk update \
    && apk del php7-fpm nginx\
    && apk del --purge *-dev \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7 \
    && touch /etc/s6-overlay/s6-rc.d/user/contents.d/crontab \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

