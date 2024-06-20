#!/bin/sh

exec /socat -u UDP-LISTEN:514 UNIX-SENDTO:/dev/log
