#!/usr/bin/env bash

test -r /tmp/healthcheck-ip || exit 1

healthcheck_ip=$(cat /tmp/healthcheck-ip 2> /dev/null)

test -z "${healthcheck_ip}" && exit 1

retval=$(
	for domain in anyqast-dnstest.com anyqast-dnstest.org; do
		for test in 'A 0.0.0.0' 'AAAA ::' 'TXT "'"${domain}"'"' 'MX 0 '"${domain}"'.'; do
			read qtype expected <<<$(echo "${test}")
			result=$(dig +short +tries=1 +timeout=1 +noall +answer "@${healthcheck_ip}" -c IN -q "$(cat /dev/urandom | head -c 512 | sha512sum | head -c 16).${domain}." -t "${qtype}" 2>&1)
			test "${result}" == "${expected}" && echo 0 || (echo 1; echo "Failed dnstest: domain=${domain} qtype=${qtype} expected=${expected} result=${result}" 1>&2)
		done
	done | sort | uniq -c | sort -rn | head -n1 | awk '{print $2}'
)
exit "${retval}"
