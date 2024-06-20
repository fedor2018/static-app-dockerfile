#!/bin/sh

CONF=/config/tinyproxy.conf
if [ ! -f $CONF ];
then
    echo "Using default config";
    cp -r /default/* /config/;
fi;

#mkdir -p /tmp/tor

ln -sf /dev/stderr /tmp/tinyproxy.log

exec /tinyproxy -d -c /config/tinyproxy.conf $@

