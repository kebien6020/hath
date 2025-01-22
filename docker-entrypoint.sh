#!/bin/sh

if [ -z "$CLIENT_ID" ]; then
    >&2 echo "CLIENT_ID not set"
    exit 1
fi
if [ -z "$CLIENT_KEY" ]; then
    >&2 echo "CLIENT_KEY not set"
    exit 1
fi

echo -n "$CLIENT_ID-$CLIENT_KEY" > /app/data/client_login

set -x
exec java -jar /app/HentaiAtHome.jar \
    --cache-dir=/app/cache \
    --data-dir=/app/data \
    --log-dir=/app/log \
    --download-dir=/app/download \
    --temp-dir=/tmp
