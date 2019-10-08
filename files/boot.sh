#!/usr/bin/env bash

ip2long() {
	local o1 o2 o3 o4
	IFS=. read -r o1 o2 o3 o4 <<< "${1}"
	echo -n "$(($((${o4}))+$((${o3}*256))+$((${o2}*256*256))+$((${o1}*256*256*256))))"
}
long2ip() {
	echo -n "$((${1}>>24&255)).$((${1}>>16&255)).$((${1}>>8&255)).$((${1}&255))"
}

test -z "${HEALTHCHECK_IP_RANGE_START}" && HEALTHCHECK_IP_RANGE_START=127.0.0.2
test -z "${HEALTHCHECK_IP_RANGE_END}" && HEALTHCHECK_IP_RANGE_END=127.0.0.2

HEALTHCHECK_IP_RANGE_START=$(ip2long "${HEALTHCHECK_IP_RANGE_START}")
HEALTHCHECK_IP_RANGE_END=$(ip2long "${HEALTHCHECK_IP_RANGE_END}")

export HEALTHCHECK_LISTEN_IP=$(long2ip $(shuf -i "${HEALTHCHECK_IP_RANGE_START}-${HEALTHCHECK_IP_RANGE_END}" -n 1))

echo "Listening for healthchecks on ${HEALTHCHECK_LISTEN_IP}"

echo "${HEALTHCHECK_LISTEN_IP}" > /tmp/healthcheck-ip

exec "/usr/bin/supervisord" "-kc/etc/supervisord.conf"

