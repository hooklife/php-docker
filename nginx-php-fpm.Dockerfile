ARG BASE_IMAGE
FROM $BASE_IMAGE


RUN set -ex \
    && echo -e "\033[42;37m Build Completed :).\033[0m\n"

