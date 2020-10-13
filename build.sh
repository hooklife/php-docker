#!/bin/bash

set -e


TASK=${1}

function build_and_push(){
    VERSION=${1}
    ALPINE_VERSION=${2}
    PHP_VERSION=${3}
    build ${VERSION} ${ALPINE_VERSION} ${PHP_VERSION}
    push ${VERSION} ${ALPINE_VERSION} ${PHP_VERSION}
}
function build() {
    VERSION=${1}
    ALPINE_VERSION=${2}
    PHP_VERSION=${3}
    echo ${3}
    docker build --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg PHP_VERSION=${PHP_VERSION} --build-arg VERSION=${VERSION} -t hooklife/php-docker:base-${PHP_VERSION}-${ALPINE_VERSION}-${VERSION} -f Dockerfile.base .
    docker build --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg PHP_VERSION=${PHP_VERSION} --build-arg VERSION=${VERSION} -t hooklife/php-docker:php-fpm-${PHP_VERSION}-${ALPINE_VERSION}-${VERSION} -f Dockerfile.php-fpm .
    docker build --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg PHP_VERSION=${PHP_VERSION} --build-arg VERSION=${VERSION} -t hooklife/php-docker:php-fpm-nginx-${PHP_VERSION}-${ALPINE_VERSION}-${VERSION} -f Dockerfile.php-fpm-nginx .
    docker build --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg PHP_VERSION=${PHP_VERSION} --build-arg VERSION=${VERSION} -t hooklife/php-docker:laravel-all-in-one-${PHP_VERSION}-${ALPINE_VERSION}-${VERSION} -f Dockerfile.laravel-all-in-one .
    # docker build -t hooklife/laravel-all-in-one:base-{$ALPINE_VERSION}-${PHP_VERSION} -f Dockerfile.php-fpm
    # docker build -t hooklife/laravel-all-in-one:base-{$ALPINE_VERSION}-${PHP_VERSION} -f Dockerfile.php-fpm-nginx
    # docker build -t hooklife/laravel-all-in-one:base-{$ALPINE_VERSION}-${PHP_VERSION} -f Dockerfile.laravel-all-in-one
}
function push(){
    VERSION=${1}
    ALPINE_VERSION=${2}
    PHP_VERSION=${3}
    docker push hooklife/php-docker:base-${PHP_VERSION}-${ALPINE_VERSION}-${VERSION}
    docker push hooklife/php-docker:php-fpm-${PHP_VERSION}-${ALPINE_VERSION}-${VERSION}
    docker push hooklife/php-docker:php-fpm-nginx-${PHP_VERSION}-${ALPINE_VERSION}-${VERSION}
    docker push hooklife/php-docker:laravel-all-in-one-${PHP_VERSION}-${ALPINE_VERSION}-${VERSION}
}



if [[ ${TASK} == "base" ]]; then
    VERSION=${2}
    #build_and_push ${VERSION} 3.11 7.1
    #build_and_push ${VERSION} 3.11 7.2
    #build_and_push ${VERSION} 3.11 7.3
    build_and_push ${VERSION} 3.11 7.4
fi
