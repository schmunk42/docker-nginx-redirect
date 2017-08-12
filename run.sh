#!/usr/bin/env sh

if [ ! -n "$SERVER_REDIRECT" ] ; then
    echo "Environment variable SERVER_REDIRECT is not set, exiting."
    exit 1
fi

# set redirect path from optional ENV var
if [ ! -n "$SERVER_REDIRECT_PATH" ] ; then
    SERVER_REDIRECT_PATH='$request_uri'
fi

sed -i "s|\${SERVER_REDIRECT}|${SERVER_REDIRECT}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_PATH}|${SERVER_REDIRECT_PATH}|" /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'
