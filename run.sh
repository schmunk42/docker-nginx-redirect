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
    SERVER_REDIRECT_SCHEME='$redirect_scheme'
fi

# set access log location from optional ENV var
if [ ! -n "$SERVER_ACCESS_LOG" ] ; then
    SERVER_ACCESS_LOG='/dev/stdout'
fi

# set error log location from optional ENV var
if [ ! -n "$SERVER_ERROR_LOG" ] ; then
    SERVER_ERROR_LOG='/dev/stderr'
fi

# set endpoint for healthcheck from optional ENV var
if [ ! -n "$HEALTH_CHECK_URL" ] ; then
    HEALTH_CHECK_URL='healthz'
fi

sed -i "s|\${SERVER_REDIRECT}|${SERVER_REDIRECT}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_NAME}|${SERVER_NAME}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_CODE}|${SERVER_REDIRECT_CODE}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_POST_CODE}|${SERVER_REDIRECT_POST_CODE}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_PATH}|${SERVER_REDIRECT_PATH}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_SCHEME}|${SERVER_REDIRECT_SCHEME}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${HEALTH_CHECK_URL}|${HEALTH_CHECK_URL}|" /etc/nginx/conf.d/default.conf

ln -sfT "$SERVER_ACCESS_LOG" /var/log/nginx/access.log
ln -sfT "$SERVER_ERROR_LOG" /var/log/nginx/error.log

exec nginx -g 'daemon off;'
