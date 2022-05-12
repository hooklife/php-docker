#!/bin/sh
while true
do
  sleep .5
  RESPONSE=$(
    SCRIPT_NAME=/ping \
    SCRIPT_FILENAME=/ping \
    REQUEST_METHOD=GET \
    cgi-fcgi -bind -connect /var/run/php7-fpm.sock || true)
  case $RESPONSE in
    *"pong"*)
      echo "FPM is running and ready. Starting nginx."
      break
  esac
  echo "wait php-fpm"
done


