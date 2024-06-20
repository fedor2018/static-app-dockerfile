#!/bin/sh

#microsocks -1 -i listenip -p port -u user -P password -b bindaddr
#default listenip is 0.0.0.0 and port 1080

[ -z "$LISTEN_IP" ] && LISTEN_IP=127.0.0.1
[ -n "$BIND_IP" ] && BIND_IP="-b $BIND_IP"
[ -n "$PORT" ] && PORT="-p $PORT"
[ -n "$USER" ] && USER="-u $USER"
[ -n "$PASS" ] && PASS="-P $PASS"

exec /microsocks -i $LISTEN_IP $PORT $USER $PASS $BIND_IP $@

