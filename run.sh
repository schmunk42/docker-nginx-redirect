#!/usr/bin/env sh

if [ ! -n "$SERVER_REDIRECT" ] ; then
    echo "Environment variable SERVER_REDIRECT is not set, exiting."
    exit 1
fi

# set server name from optional ENV var
if [ ! -n "$SERVER_NAME" ] ; then
    SERVER_NAME='localhost'
fi

# set redirect code from optional ENV var
# allowed Status Codes are: 301, 302, 303, 307, 308
expr match "$SERVER_REDIRECT_CODE" '30[12378]$' > /dev/null || SERVER_REDIRECT_CODE='301'

# set redirect code from optional ENV var for POST requests
expr match "$SERVER_REDIRECT_POST_CODE" '30[12378]$' > /dev/null || SERVER_REDIRECT_POST_CODE=$SERVER_REDIRECT_CODE

# set redirect path from optional ENV var
if [ ! -n "$SERVER_REDIRECT_PATH" ] ; then
    SERVER_REDIRECT_PATH='$request_uri'
fi

# set redirect scheme from optional ENV var
if [ ! -n "$SERVER_REDIRECT_SCHEME" ] ; then
    SERVER_REDIRECT_SCHEME='$scheme'
fi

sed -i "s|\${SERVER_REDIRECT}|${SERVER_REDIRECT}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_NAME}|${SERVER_NAME}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_CODE}|${SERVER_REDIRECT_CODE}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_POST_CODE}|${SERVER_REDIRECT_POST_CODE}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_PATH}|${SERVER_REDIRECT_PATH}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_SCHEME}|${SERVER_REDIRECT_SCHEME}|" /etc/nginx/conf.d/default.conf

exec nginx -g 'daemon off;'
