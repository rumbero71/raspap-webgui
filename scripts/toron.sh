#!/bin/bash
PRIVOXY_CONFIG=/etc/privoxy/config
ps ax | grep tor | grep -v grep | grep -v sh >/dev/null 2>&1
if [ $? -eq 0 ]; then
	systemctl stop tor
fi
systemctl stop privoxy
THISLINENO=`grep -n "###NOTOR" /etc/privoxy/config | grep -v "^#" | awk -F: '{ print $1 }'`
if [ -z $THISLINENO ]; then
        echo "Privoxy not configured for tor ! Exiting..."
        exit 1
fi
cat /etc/privoxy/config | sed -e "${THISLINENO}s/.*/forward-socks5\t\/\t127.0.0.1:9050\t./" >/tmp/pcconfig
cp -f /tmp/pcconfig /etc/privoxy/config
rm -f /tmp/pcconfig
systemctl start tor
systemctl start privoxy
