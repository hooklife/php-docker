ARG BASE_IMAGE
FROM $BASE_IMAGE


RUN set -ex \
    && ln -s /etc/services.example/php-fpm /etc/services.d \
    && ln -s /etc/services.example/nginx /etc/services.d \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

