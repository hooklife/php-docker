#!/usr/bin/with-contenv sh
if [[ "$ENABLE_CRONTAB" == "1" ]]; then
    echo '*  *  *  *  * /usr/local/bin/php  /app/artisan schedule:run >> /dev/null 2>&1' > /etc/crontabs/root
fi