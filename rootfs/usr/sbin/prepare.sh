#!/command/with-contenv sh
echo date.timezone=$(cat /etc/timezone) > /etc/php7/conf.d/99-timezone.ini

sed -i "s/pm.max_children = PM_MAX_CHILDREN/pm.max_children = ${PM_MAX_CHILDREN:=20}/" /usr/local/etc/php-fpm.d/www.conf

if [[ "$PHP_ENABLE_OPCACHE" == "1" ]]; then
    echo "============> ENABLE PHP OPCACHE"
    sed -i "s/opcache.enable = 0/opcache.enable = 1/" /etc/php7/conf.d/90_opcache.ini
    sed -i "s/opcache.enable_cli = 0/opcache.enable = 1/" /etc/php7/conf.d/90_opcache.ini
fi

# reset the PHP memory limit
if [[ ! -z "${PHP_MEMORY_LIMIT}" ]]; then
    echo "============> Reseting PHP memory limit"
    sed -i "s/memory_limit = 512M/memory_limit = ${PHP_MEMORY_LIMIT}/" /etc/php7/conf.d/90_general.ini
fi

if [[ "$ENABLE_CRONTAB" == "1" ]]; then
    echo '*  *  *  *  * /usr/local/bin/php  /app/artisan schedule:run >> /dev/null 2>&1' > /etc/crontabs/root
fi

