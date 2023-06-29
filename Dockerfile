ARG BUILD_IMAGE="almalinux:8-minimal"
ARG USER_GID="1000"
ARG USER_PID="1000"

FROM ${BUILD_IMAGE}
ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_USER=squid

COPY ./container_resources/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN microdnf update -y && \
    microdnf install -y squid sudo && \
    mkdir /config && \
    cp /etc/squid/squid.conf /config/. && \
    chown -R ${USER_PID}:${USER_GID} /config && \
    microdnf clean all && \
    rm -rf /tmp/* && \
    rm -rf /usr/local/share/man/* && \
    chmod +x /usr/local/bin/entrypoint.sh && \
    echo -e "Defaults:squid !requiretty" > /etc/sudoers.d/squid &&\
    echo -e "squid ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/squid && \
    mkdir -p ${SQUID_CACHE_DIR} && \
    chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}

COPY container_resources/etc/squid/squid.d /etc/squid/squid.d
VOLUME /config
EXPOSE 3128/tcp

USER squid
ENTRYPOINT ["sudo", "/usr/local/bin/entrypoint.sh"]
