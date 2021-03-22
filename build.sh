#!/bin/bash

set -e


TASK=${1}

function build_and_push(){
    VERSION=${1}
    ALPINE_VERSION=${2}
    PHP_VERSION=${3}
    build ${VERSION} ${ALPINE_VERSION} ${PHP_VERSION}
}

function build() {
    VERSION=${1}
    ALPINE_VERSION=${2}
    PHP_VERSION=${3}

    BASE_IMAGE_TAG=${PHP_VERSION}-c1-${VERSION}
    BASE_IMAGE=${BASE_IMAGE_NAME}-${BASE_IMAGE_TAG}


    docker build --build-arg COMPOSER_VERSION=1 --build-arg  ALPINE_VERSION=${ALPINE_VERSION} --build-arg PHP_VERSION=${PHP_VERSION} --build-arg VERSION=${VERSION} -t hooklife/php-docker:php-fpm-${BASE_IMAGE_TAG} -f php-fpm.Dockerfile .
    docker push hooklife/php-docker:php-fpm-${BASE_IMAGE_TAG}

    docker build --build-arg BASE_IMAGE=hooklife/php-docker:php-fpm-${BASE_IMAGE_TAG} -t  hooklife/php-docker:crontab-${BASE_IMAGE_TAG} -f crontab.Dockerfile .
    docker push hooklife/php-docker:crontab-${BASE_IMAGE_TAG}
    
    docker build --build-arg BASE_IMAGE=hooklife/php-docker:php-fpm-${BASE_IMAGE_TAG} -t  hooklife/php-docker:horizon-${BASE_IMAGE_TAG} -f horizon.Dockerfile .
    docker push hooklife/php-docker:horizon-${BASE_IMAGE_TAG}

    docker build --build-arg BASE_IMAGE=hooklife/php-docker:php-fpm-${BASE_IMAGE_TAG} -t  hooklife/php-docker:nginx-php-fpm-${BASE_IMAGE_TAG} -f nginx-php-fpm.Dockerfile .
    docker push hooklife/php-docker:nginx-php-fpm-${BASE_IMAGE_TAG}
}



if [[ ${TASK} == "base" ]]; then
    VERSION=${2}
    build_and_push ${VERSION} 3.11 7.3
    build_and_push ${VERSION} 3.11 7.4
    build_and_push ${VERSION} 3.11 8.0
fi
