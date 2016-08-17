FROM alpine:3.3
MAINTAINER Marc Fisher <mcfisher83@gmail.com>

RUN echo "ipv6" >> /etc/modules
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories; \
    echo "http://dl-2.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories; \
    echo "http://dl-3.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories; \
    echo "http://dl-4.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories; \
    echo "http://dl-5.alpinelinux.org/alpine/v3.3/main" >> /etc/apk/repositories

# Add commonly used packages
RUN apk add --no-cache bind-tools

# Add s6-overlay
ENV S6_OVERLAY_VERSION=v1.17.2.0 \
    GODNSMASQ_VERSION=1.0.6

RUN apk add --no-cache curl && \
    curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz \
    | tar xfz - -C / && \
    curl -sSL https://github.com/janeczku/go-dnsmasq/releases/download/${GODNSMASQ_VERSION}/go-dnsmasq-min_linux-amd64 -o /bin/go-dnsmasq && \
    chmod +x /bin/go-dnsmasq && \
    apk del curl

RUN apk add --update nginx && rm -rf /var/cache/apk/*

ADD root /

# expose both the HTTP (80) and HTTPS (443) ports
EXPOSE 80 443

CMD ["nginx"]
