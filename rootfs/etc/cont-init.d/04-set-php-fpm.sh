#!/usr/bin/with-contenv sh

sed -i "s/pm.max_children = PM_MAX_CHILDREN/pm.max_children = ${PM_MAX_CHILDREN:=20}/" /usr/local/etc/php-fpm.d/www.conf
