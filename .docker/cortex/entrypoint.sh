#!/bin/bash

function usage {
	cat <<- _EOF_
		Available options:
		--no-config		| do not try to configure TheHive (add secret and elasticsearch)
		--no-config-secret	| do not add random secret to configuration
		--no-config-es		| do not add elasticsearch hosts to configuration
		--es-uri <uri>		| use this string to configure elasticsearch hosts (format: http(s)://host:port,host:port(/prefix)?querystring)
		--es-hostname <host>	| resolve this hostname to find elasticseach instances
		--secret <secret>	| secret to secure sessions
		--show-secret		| show the generated secret
		--analyzer-url <url>	| where analyzers are located (url or path)
		--responder-url <url>	| where responders are located (url or path)
		--start-docker		| start a internal docker (inside container) to run analyzers/responders
	_EOF_
	exit 1
}

set -x

ES_HOSTNAME=${ES_HOSTNAME:-"elasticsearch"}
ES_URI=${ES_URI:-"http://$ES_HOSTNAME:9200"}
CONFIG_SECRET=${CONFIG_SECRET:-"1"}
CONFIG_ES=${CONFIG_ES:-"1"}
CONFIG=${CONFIG:-"1"}
CONFIG_FILE=${CONFIG_FILE:-"/etc/cortex/docker-application.conf"}
ANALYZER_PATH=${ANALYZER_PATH:-"/etc/cortex/analyzers.json"}
ANALYZER_URLS=${ANALYZER_URLS:-"()"}
RESPONDER_PATH=${RESPONDER_PATH:-"/etc/cortex/responders.json"}
RESPONDER_URLS=${RESPONDER_URLS:-"()"}
START_DOCKER=${START_DOCKER:-"0"}
SHOW_SECRET=${SHOW_SECRET:-"0"}
DOCKER_GID=${DOCKER_GID:-"999"}



STOP=0
while test $# -gt 0 -o $STOP = 1
do
	case "$1" in
		"--no-config")		CONFIG=0;;
		"--no-config-secret")	CONFIG_SECRET=0;;
		"--no-config-es")	CONFIG_ES=0;;
		"--es-hosts")		echo "--es-hosts is deprecated, please use --es-uri"
					usage;;
		"--es-uri")		shift; ES_URI=$1;;
		"--es-hostname")	shift; ES_HOSTNAME=$1;;
		"--secret")		shift; SECRET=$1;;
		"--show-secret")	SHOW_SECRET=1;;
		"--analyzer-path")	shift; ANALYZER_PATH=$1;;
		"--responder-path")	shift; RESPONDER_PATH=$1;;
		"--analyzer-url")	shift; ANALYZER_URLS+=$1;;
		"--responder-url")	shift; RESPONDER_URLS+=$1;;
		#"--start-docker")	START_DOCKER=1;;
		"--")			STOP=1;;
		*)			echo "unrecognized option: $1"; usage;;
	esac
	shift
done

if test $CONFIG = 1
then
	#CONFIG_FILE=$(mktemp).conf
	echo "# Runtime generated configuration at $(date)" > "$CONFIG_FILE"

	if test $CONFIG_SECRET = 1
	then
		if test -z "$SECRET"
		then
			#shellcheck disable=SC2002
			SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1)
			test $SHOW_SECRET = 1 && echo "Using secret: $SECRET"
		fi
		echo "play.http.secret.key=\"$SECRET\"" >> "$CONFIG_FILE"
	fi

	if test $CONFIG_ES = 1
	then
		if test -z "$ES_URI"
		then
			function join_es_hosts {
				echo -n "$1:9200"
				shift
				printf "%s," "${@/#/:9200}"
			}

			ES=$(getent ahostsv4 "$ES_HOSTNAME" | awk '{ print $1 }' | sort -u)
			if test -z "$ES"
			then
				echo "Warning automatic elasticsearch host config fails"
			else
				ES_URI=http://$(join_es_hosts "$ES")
			fi
		fi
		if test -n "$ES_URI"
		then
			echo "Using elasticsearch uri: $ES_URI"
			echo "search.uri=\"$ES_URI\"" >> "$CONFIG_FILE"
			sed -i "s,.*#ssl_password_file.*,ssl_password_file ${SSL_PASSPHRASE_FILE};," "$MAINTENANCE_CONFIG"
		else
			echo "elasticsearch host not configured"
		fi
	fi

	function join_urls {
		#shellcheck disable=SC2086
		echo -n \"$1\"
		shift
		#shellcheck disable=SC2086
		for U do echo -n ,\"$U\"; done
#		printf ",\"%s\"" $@
	}
	# test ${#ANALYZER_URLS} = 0 && ANALYZER_URLS+=$ANALYZER_PATH
	# test ${#RESPONDER_URLS} = 0 && RESPONDER_URLS+=$RESPONDER_PATH
	
	# echo analyzer.urls=\[$(join_urls ${ANALYZER_URLS[@]})\] >> "$CONFIG_FILE"
	# echo responder.urls=\[$(join_urls ${RESPONDER_URLS[@]})\] >> "$CONFIG_FILE"

	
	# Add default config file for all other options:
	echo 'include file("/etc/cortex/application.conf")' >> "$CONFIG_FILE"

fi


# Docker settings
	# Add docker group
	addgroup docker --gid "$DOCKER_GID"
	# Add group to current user
	usermod -a -G docker cortex


echo "config file $CONFIG_FILE is:"
echo "##################"
cat "$CONFIG_FILE"
echo "##################"
gosu cortex /opt/cortex/bin/cortex \
	-Dconfig.file="$CONFIG_FILE" \
	-Dlogger.file=/etc/cortex/logback.xml \
	-Dpidfile.path=/dev/null \
	"$@"
