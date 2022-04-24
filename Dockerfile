FROM debian:bullseye

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        extrepo && \
    extrepo enable prosody && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y prosody && \ 
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/prosody && chown prosody:prosody /var/run/prosody

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN mkdir -p /etc/prosody/conf.d
RUN mkdir -p /etc/prosody/vhost.d
RUN mkdir -p /etc/prosody/cmpt.d
COPY ./prosody.cfg.lua /etc/prosody
COPY ./admins.cfg.lua /etc/prosody
COPY ./conf.d/ /etc/prosody/conf.d/

EXPOSE 80 443 5222 5269 5347 5280 5281
ENV __FLUSH_LOG yes
CMD ["prosody", "-F"]