#!/bin/sh

CONF=/config/torrc
if [ ! -f $CONF ];
then
    echo "Using default config";
    cp -r /default/* /config/;
fi;

mkdir -p /tmp/tor

exec /tor --hush -f /config/torrc
