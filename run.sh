#!/usr/bin/env bash

if [ ! -n "$SERVER_REDIRECT" ] ; then
    echo "Environment variable SERVER_REDIRECT is not set, exiting."
    exit 1
fi

sed -i "s|\${SERVER_REDIRECT}|${SERVER_REDIRECT}|" /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'
