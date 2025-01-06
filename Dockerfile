FROM ubuntu:jammy
LABEL maintainer="sameer@damagehead.com"

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy

    RUN echo "deb http://archive.ubuntu.com/ubuntu focal main universe" > /etc/apt/sources.list.d/focal.list \
    && echo "deb http://archive.ubuntu.com/ubuntu focal-updates main universe" >> /etc/apt/sources.list.d/focal.list \
    && echo "deb http://security.ubuntu.com/ubuntu focal-security main universe" >> /etc/apt/sources.list.d/focal.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y squid \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/apt/sources.list.d/focal.list


COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
