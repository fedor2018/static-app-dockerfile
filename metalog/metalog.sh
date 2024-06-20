#!/bin/sh

mkdir -p /config/log

[ ! -f /config/metalog.conf ] && cp /etc/metalog.conf /config/

exec /metalog -N -a -C /config/metalog.conf -p /tmp/metalog.pid
