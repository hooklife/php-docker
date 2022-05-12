ARG BASE_IMAGE
FROM $BASE_IMAGE


RUN set -ex \
    && touch /etc/s6-overlay/s6-rc.d/user/contents.d/nginx \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

