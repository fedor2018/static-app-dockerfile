#!/bin/sh
set -e

if [ ! -f /config/redis.conf ];then
    cp /etc/redis.conf /config/
fi

#	find . \! -user redis -exec chown redis '{}' +
exec /bin/redis-server /config/redis.conf
