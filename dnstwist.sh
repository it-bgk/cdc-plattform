#!/bin/bash
set -x
# https://github.com/elceef/dnstwist
docker run --rm -ti elceef/dnstwist "$@"