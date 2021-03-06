FROM debian:stable-slim
ENV CONFIG_FILE=/etc/thehive/application.conf
ENV DATA_PATH=/opt/thp_data/files/thehive
WORKDIR ${DATA_PATH}

RUN set -eu \
    # https://github.com/geerlingguy/ansible-role-java/issues/64#issuecomment-393299088
    ;mkdir -p /usr/share/man/man1 \
    ;apt-get update \
    ;apt-get install -y --no-install-recommends \
        curl \
        gnupg2 \
        ca-certificates \
    ;curl https://raw.githubusercontent.com/TheHive-Project/TheHive/master/PGP-PUBLIC-KEY | apt-key add - \
    ;echo 'deb https://deb.thehive-project.org release main' | tee -a /etc/apt/sources.list.d/thehive-project.list \
    ;apt-get purge -y \
        gnupg2 \
    ;apt-get autoremove -y \
    ;rm -Rf /var/lib/apt/lists/* \
    ;

ARG VERSION
ENV VERSION ${VERSION}
RUN set -eu \
    ;apt-get update \
    ;apt-get install -y --no-install-recommends  \
        thehive4=${VERSION}-1 \
    ;apt-get autoremove -y \
    ;rm -Rf /var/lib/apt/lists/* \
    ;

# Add S6 Overlay
ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz /tmp/
RUN set -eu \
    ;tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    ;

COPY --chown=thehive:thehive application.conf /etc/thehive/
#COPY s6/permissions /etc/fix-attrs.d/00-thehive-set-permissions
COPY s6/thehive/prepare /etc/cont-init.d/00-thehive-prepare
COPY s6/thehive/run /etc/services.d/thehive/run
COPY s6/thehive/default_vars.sh /default_vars.sh

ENTRYPOINT ["/init"]
HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 CMD curl --fail http://127.0.0.1:9000 || exit 1
