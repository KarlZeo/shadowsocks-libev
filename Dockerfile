#
# Dockerfile for shadowsocks-libev
#

FROM alpine:edge
MAINTAINER Tony.Shao <xiocode@gmail.com>

ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev.git
ENV SS_DIR shadowsocks-libev
ENV SS_DEP git autoconf build-base curl libtool linux-headers openssl-dev asciidoc xmlto

RUN set -ex \
    && apk --no-cache --update add $SS_DEP \
    && git clone $SS_URL \
    && cd $SS_DIR \
    && ./configure \
    && make install \
    && cd .. \
    && rm -rf $SS_DIR \
    && apk del --purge $SS_DEP \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD 1234567890
ENV METHOD chacha20
ENV TIMEOUT 300
ENV DNS_ADDR 8.8.8.8

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp

COPY ./docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
