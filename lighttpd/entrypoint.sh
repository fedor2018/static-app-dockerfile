#!/bin/sh

CONF=/config/lighttpd.conf
if [ ! -f $CONF ];
then
    echo "Using default config";
    cp -r /default/* /config/;
fi;

ln -sf /dev/stdout /tmp/access.log
ln -sf /dev/stderr /tmp/error.log

exec /bin/lighttpd -D -f /config/lighttpd.conf
