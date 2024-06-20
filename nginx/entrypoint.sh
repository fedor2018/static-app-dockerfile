#!/bin/sh

CONF=/config/nginx.conf
if [ ! -f $CONF ];
then
    echo "Using default config";
    CONF=/default/nginx.conf
#    mkdir -p /config
#    cp -rv /default/* /config/;
fi;

mkdir -p /tmp
cd /tmp
mkdir -p client_temp proxy_temp fastcgi_temp uwsgi_temp scgi_temp
echo "START: "`date`
if [ -n "$1" ];then
exec /bin/nginx $@
else
exec /bin/nginx -g "daemon off;" -c $CONF
fi
