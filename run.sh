#!/usr/bin/env sh

if [ ! -n "$SERVER_REDIRECT" ] ; then
    echo "Environment variable SERVER_REDIRECT is not set, exiting."
    exit 1
fi

# set redirect code from optional ENV var
# allowed Status Codes are: 301, 302, 303, 307, 308
expr match "$SERVER_REDIRECT_CODE" '30[12378]$' > /dev/null || SERVER_REDIRECT_CODE='301'

# set redirect code from optional ENV var for POST requests
expr match "$SERVER_REDIRECT_POST_CODE" '30[12378]$' > /dev/null || SERVER_REDIRECT_POST_CODE=$SERVER_REDIRECT_CODE

# set redirect code from optional ENV var for PUT, PATCH and DELETE requests
expr match "$SERVER_REDIRECT_PUT_PATCH_DELETE_CODE" '30[12378]$' > /dev/null || SERVER_REDIRECT_PUT_PATCH_DELETE_CODE=$SERVER_REDIRECT_CODE

sed -i "s|\${SERVER_REDIRECT}|${SERVER_REDIRECT}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_NAME}|${SERVER_NAME}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_CODE}|${SERVER_REDIRECT_CODE}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_POST_CODE}|${SERVER_REDIRECT_POST_CODE}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_PUT_PATCH_DELETE_CODE}|${SERVER_REDIRECT_PUT_PATCH_DELETE_CODE}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_PATH}|${SERVER_REDIRECT_PATH}|" /etc/nginx/conf.d/default.conf
sed -i "s|\${SERVER_REDIRECT_SCHEME}|${SERVER_REDIRECT_SCHEME}|" /etc/nginx/conf.d/default.conf

# optionally add healthcheck endpoint
if [ $SERVER_HEALTHCHECK_ENABLED = 1 ]; then
    sed -i "s|\${HEALTHCHECK_LOCATION_BLOCK}|include includes/healthcheck.conf;|" /etc/nginx/conf.d/default.conf

    sed -i "s|\${SERVER_HEALTHCHECK_PATH}|${SERVER_HEALTHCHECK_PATH}|" /etc/nginx/includes/healthcheck.conf
    sed -i "s|\${SERVER_HEALTHCHECK_RESPONSE_CODE}|${SERVER_HEALTHCHECK_RESPONSE_CODE}|" /etc/nginx/includes/healthcheck.conf
    sed -i "s|\${SERVER_HEALTHCHECK_RESPONSE_BODY}|${SERVER_HEALTHCHECK_RESPONSE_BODY}|" /etc/nginx/includes/healthcheck.conf
else
    sed -i "s|\${HEALTHCHECK_LOCATION_BLOCK}||" /etc/nginx/conf.d/default.conf
fi

ln -sfT "$SERVER_ACCESS_LOG" /var/log/nginx/access.log
ln -sfT "$SERVER_ERROR_LOG" /var/log/nginx/error.log

exec nginx -g 'daemon off;'
