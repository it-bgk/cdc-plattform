FROM debian:stable-slim as builder
ENV CONFIG_FILE=/etc/cortex/application.conf
ENV DATA_PATH=/opt/cortex
WORKDIR ${DATA_PATH}

# Install latest Cortex from DEB package
RUN set -eu \
    # https://github.com/geerlingguy/ansible-role-java/issues/64#issuecomment-393299088
    ;mkdir -p /usr/share/man/man1 \
    ;apt-get update \
    ;apt-get install -y --no-install-recommends  \
        gnupg2 \
        ca-certificates \ 
        curl \
        git \
    #;echo 'deb https://deb.thehive-project.org stable main es7' | tee -a /etc/apt/sources.list.d/thehive-project.list \
    ;echo 'deb https://deb.thehive-project.org release main' | tee -a /etc/apt/sources.list.d/thehive-project.list \
    ;curl https://raw.githubusercontent.com/TheHive-Project/Cortex/master/PGP-PUBLIC-KEY| apt-key add - \
    ;apt-get update \
    ;apt-get install -y --no-install-recommends \
        cortex \
    #;apt-get purge -y gnupg \
    ;apt-get autoremove -y \
    ;rm -Rf /var/lib/apt \
    ;

# Add base responder and analyzer cortex file:
ADD https://dl.bintray.com/thehive-project/cortexneurons/responders-stable.json /etc/cortex/responders.json
ADD https://dl.bintray.com/thehive-project/cortexneurons/analyzers-stable.json /etc/cortex/analyzers.json

# Add S6 Overlay
ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64.tar.gz /tmp/
RUN set -eu \
    ;tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
    ;

# Add additional ressources
RUN set -eu \
    ;git clone https://github.com/firehol/blocklist-ipsets.git /opt/cortex/analyzer_files/FireHOLBlocklists \
    ;git clone https://github.com/MISP/misp-warninglists.git /opt/cortex/analyzer_files/misp-warninglists \
    ;git clone https://github.com/norgalades/SendEmail.git /opt/cortex/responders/SendEmail \
    # NSLR preparation, files can be added only manual
    ;mkdir /opt/cortex/analyzer_files/nslr \
    ;

COPY application.conf /etc/cortex/
#COPY s6/permissions /etc/fix-attrs.d/00-cortex-set-permissions
COPY s6/cortex/prepare /etc/cont-init.d/00-cortex-prepare
COPY s6/cortex/run /etc/services.d/cortex/run

ENTRYPOINT ["/init"]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "curl", "http://127.0.0.1:9001" ]

ENV job_directory="/tmp/cortex-jobs"