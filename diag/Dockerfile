FROM alpine

RUN apk -U --no-cache add \
    tcpdump bash netcat-openbsd mc \
    dnstracer dnstop bind-tools fping \
    net-tools \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

CMD /bin/bash
#tcpdump -i eth0
