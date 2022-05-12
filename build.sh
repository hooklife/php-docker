#!/bin/bash

set -e


TASK=${1}

function build_and_push(){
    VERSION=${1}
    PHP_VERSION=${2}
    build ${VERSION}  ${PHP_VERSION}
}

function build() {
    VERSION=${1}
    PHP_VERSION=${2}

    BASE_IMAGE_TAG=${PHP_VERSION}-c1-${VERSION}
    BASE_IMAGE=hooklife/php-docker:base-${BASE_IMAGE_TAG}

    
    docker build --build-arg COMPOSER_VERSION=1 --build-arg PHP_VERSION=${PHP_VERSION} --build-arg VERSION=${VERSION} -t ${BASE_IMAGE} -f base.Dockerfile .
    docker push ${BASE_IMAGE}

    docker build --build-arg BASE_IMAGE=${BASE_IMAGE} -t  hooklife/php-docker:crontab-${BASE_IMAGE_TAG} -f crontab.Dockerfile .
    docker push hooklife/php-docker:crontab-${BASE_IMAGE_TAG}
    
    docker build --build-arg BASE_IMAGE=${BASE_IMAGE} -t  hooklife/php-docker:horizon-${BASE_IMAGE_TAG} -f horizon.Dockerfile .
    docker push hooklife/php-docker:horizon-${BASE_IMAGE_TAG}

    docker build --build-arg BASE_IMAGE=${BASE_IMAGE} -t  hooklife/php-docker:nginx-php-fpm-${BASE_IMAGE_TAG} -f nginx-php-fpm.Dockerfile .
    docker push hooklife/php-docker:nginx-php-fpm-${BASE_IMAGE_TAG}
}



if [[ ${TASK} == "base" ]]; then
    VERSION=${2}
    build_and_push ${VERSION} 7.3
    build_and_push ${VERSION} 7.4
fi
