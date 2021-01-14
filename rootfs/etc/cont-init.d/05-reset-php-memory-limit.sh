#!/usr/bin/with-contenv sh

# reset the PHP memory limit
if [[ ! -z "${PHP_MEMORY_LIMIT}" ]]; then
    echo "============> Reseting PHP memory limit"
    sed -i "s/memory_limit = 512M/memory_limit = ${PHP_MEMORY_LIMIT}/" /etc/php7/conf.d/90_general.ini
fi