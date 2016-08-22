#
# Dockerfile for shadowsocks-libev
#

FROM alpine:edge
MAINTAINER Tony.Shao <xiocode@gmail.com>

ENV SS_VER 2.4.8
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz
ENV SS_DIR shadowsocks-libev-$SS_VER
ENV SS_DEP autoconf build-base curl libtool linux-headers openssl-dev asciidoc xmlto

RUN set -ex \
    && apk --no-cache --update add $SS_DEP \
    && curl -sSL $SS_URL | tar xz \
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

CMD ss-server -s $SERVER_ADDR \
              -p $SERVER_PORT \
              -k $PASSWORD \
              -m $METHOD \
              -t $TIMEOUT \
              -d $DNS_ADDR \
              --fast-open \
              -u
