# syntax=docker/dockerfile:1

ARG ADGUARD_VERSION=v0.107.63

FROM adguard/adguardhome:${ADGUARD_VERSION} AS source

FROM alpine:3.22 AS custom

ARG ADGUARD_VERSION=v0.107.56
ARG UID=1000
ARG GID=1000
ARG SERVICE_USER=adguard

RUN addgroup --system -g ${GID} ${SERVICE_USER} \
    && adduser --system -u ${UID} -G ${SERVICE_USER} -s /sbin/nologin -h /opt/adguardhome  ${SERVICE_USER}

RUN mkdir -p /etc/adguardhome /opt/adguardhome/work/data \
    && chown -R ${SERVICE_USER}:${SERVICE_USER} /etc/adguardhome /opt/adguardhome/work/data \
    && chmod -R 0700 /opt/adguardhome/work/data

RUN apk --no-cache add ca-certificates libcap tzdata

COPY --from=source --chown=${SERVICE_USER}:${SERVICE_USER}\
    /opt/adguardhome/AdGuardHome \
    /opt/adguardhome/AdGuardHome

RUN setcap 'cap_net_bind_service=+eip' /opt/adguardhome/AdGuardHome

# 53     : TCP, UDP : DNS
# 67     :      UDP : DHCP (server)
# 68     :      UDP : DHCP (client)
# 80     : TCP      : HTTP (main)
# 443    : TCP, UDP : HTTPS, DNS-over-HTTPS (incl. HTTP/3), DNSCrypt (main)
# 853    : TCP, UDP : DNS-over-TLS, DNS-over-QUIC
# 3000   : TCP, UDP : HTTP(S) (alt, incl. HTTP/3)
# 5443   : TCP, UDP : DNSCrypt (alt)
# 6060   : TCP      : HTTP (pprof)
EXPOSE 53/tcp 53/udp 67/udp 68/udp 80/tcp 443/tcp 443/udp 853/tcp\
    853/udp 3000/tcp 3000/udp 5443/tcp 5443/udp 6060/tcp

VOLUME /etc/adguardhome/ /opt/adguardhome/work

# we cannot run as service user because of https://github.com/AdguardTeam/AdGuardHome/pull/4728
# USER ${SERVICE_USER}

WORKDIR /opt/adguardhome/work

ENTRYPOINT ["/opt/adguardhome/AdGuardHome"]

CMD [ \
    "--no-check-update", \
    "-c", "/etc/adguardhome/AdGuardHome.yaml", \
    "-w", "/opt/adguardhome/work" \
    ]

LABEL\
    maintainer="mj0nez" \
    org.opencontainers.image.authors="mj0nez" \
    org.opencontainers.image.description="Network-wide ads & trackers blocking DNS server" \
    org.opencontainers.image.documentation="https://github.com/AdguardTeam/AdGuardHome/wiki/" \
    org.opencontainers.image.licenses="GPL-3.0" \
    org.opencontainers.image.source="https://github.com/mj0nez/adguardhome" \
    org.opencontainers.image.title="AdGuard Home" \
    org.opencontainers.image.url="https://hub.docker.com/r/mj0nez/adguardhome" \
    org.opencontainers.image.version=$ADGUARD_VERSION
