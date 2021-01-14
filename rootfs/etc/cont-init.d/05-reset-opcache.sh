#!/usr/bin/with-contenv sh

if [[ "$PHP_ENABLE_OPCACHE" == "1" ]]; then
    echo "============> ENABLE PHP OPCACHE"
    sed -i "s/opcache.enable = 0/opcache.enable = 1/" /etc/php7/conf.d/90_opcache.ini
    sed -i "s/opcache.enable_cli = 0/opcache.enable = 1/" /etc/php7/conf.d/90_opcache.ini
fi
