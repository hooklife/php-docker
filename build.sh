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
    docker build --build-arg ALPINE_VERSION=${ALPINE_VERSION} --build-arg PHP_VERSION=${PHP_VERSION} --build-arg VERSION=${VERSION} -t hooklife/php-docker:laravel-all-in-one-${PHP_VERSION}-${ALPINE_VERSION}-${VERSION} -f Dockerfile.laravel-all-in-one .
}
function push(){
    VERSION=${1}
    ALPINE_VERSION=${2}
    PHP_VERSION=${3}
    docker push hooklife/php-docker:laravel-all-in-one-${PHP_VERSION}-${ALPINE_VERSION}-${VERSION}
}



if [[ ${TASK} == "base" ]]; then
    VERSION=${2}
    #build_and_push ${VERSION} 3.11 7.1
    #build_and_push ${VERSION} 3.11 7.2
    #build_and_push ${VERSION} 3.11 7.3
    build_and_push ${VERSION} 3.11 7.4
fi
