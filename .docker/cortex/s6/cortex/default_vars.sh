#!/bin/sh
DEBUG=${DEBUG:-"0"}
[ $DEBUG -eq 0 ] || set -x

AUTH=${AUTH:-"local"}
AUTH_AD_DOMAINFQDN=${AUTH_AD_DOMAINFQDN}
AUTH_AD_SERVERNAMES=${AUTH_AD_SERVERNAMES}
AUTH_AD_DOMAINNAME=${AUTH_AD_DOMAINNAME}
AUTH_LDAP_SERVER=${AUTH_LDAP_SERVER}
AUTH_LDAP_BIND_DN=${AUTH_LDAP_BIND_DN}
AUTH_LDAP_BIND_PASSWORD=${AUTH_LDAP_BIND_PASSWORD}
AUTH_LDAP_BASE_DN=${AUTH_LDAP_BASE_DN}
AUTH_LDAP_FILTER=${AUTH_LDAP_FILTER}
ES_HOSTNAME=${ES_HOSTNAME:-"elasticsearch"}
ES_URI=${ES_URI:-"http://$ES_HOSTNAME:9200"}
ES_AUTH_USER=${ES_AUTH_USER}
ES_AUTH_PW=${ES_AUTH_PW}
CONFIG_FILE=${CONFIG_FILE:-"/etc/cortex/application.conf"}
DOCKER_HOST=${DOCKER_HOST:-"unix:///var/run/docker.sock"}
DOCKER_GID=${DOCKER_GID:-999} # Set the correct local docker group GID
JOB_DIRECTORY="${JOB_DIRECTORY:-"/tmp/cortex-jobs"}"
# - JAVA_OPTS=-Djavax.net.ssl.trustStore=/etc/thehive/truststore/truststore.jks
#CONFIG_SECRET=${CONFIG_SECRET:-"1"}
#CONFIG_ES=${CONFIG_ES:-"1"}
CONFIG=${CONFIG:-"1"}
# ANALYZER_PATH=${ANALYZER_PATH:-"/etc/cortex/analyzers.json"}
# ANALYZER_URLS=${ANALYZER_URLS:-"()"}
# RESPONDER_PATH=${RESPONDER_PATH:-"/etc/cortex/responders.json"}
# RESPONDER_URLS=${RESPONDER_URLS:-"()"}
SECRET="${SECRET:-"$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)"}"

