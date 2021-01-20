#!/usr/bin/with-contenv sh

if [[ "$ENABLE_COMPOSER_INSTALL" == "1" ]]; then

    echo "============> Composer install"
    echo $(pwd)
    if [ -f "/app/composer.lock" ]; then
        if [ "$APPLICATION_ENV" == "development" ]; then
            composer install --working-dir=/app
        else
            composer install --no-dev --working-dir=/app
        fi
    fi

fi
