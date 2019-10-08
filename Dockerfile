FROM cznic/knot-resolver
RUN DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -qqy --no-install-recommends -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-unsafe-io update \
 && DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -qqy --no-install-recommends -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-unsafe-io upgrade \
 && DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt-get -qqy --no-install-recommends -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-unsafe-io install luarocks gcc libssl-dev supervisor dnsutils \
 && luarocks install luafilesystem \
 && luarocks install luasec \
 && luarocks install split
ADD files /
ENTRYPOINT ["/bin/bash"]
CMD ["/boot.sh"]
HEALTHCHECK --interval=5s --timeout=15s --start-period=300s --retries=6 CMD /healthcheck.sh
