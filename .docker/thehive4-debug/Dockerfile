ARG VERSION
FROM itbgk/thehive4:${VERSION}

RUN set -eu \
    ;apt-get update \
    ;apt-get install -y --no-install-recommends  \
        vim \
        nano \
        bash \
    ;apt-get autoremove -y \
    ;rm -Rf /var/lib/apt/lists/* \
    ;