#!/bin/bash
PRIVOXY_CONFIG=/etc/privoxy/config
ps ax | grep tor | grep -v grep | grep -v sh >/dev/null 2>&1
if [ $? -eq 0 ]; then
	systemctl stop tor
fi
systemctl stop privoxy
THISLINENO=`grep -n 9050 $PRIVOXY_CONFIG | grep -v "^#" | awk -F: '{ print $1 }'`

if [ -z $THISLINENO ]; then
	echo "No line found pointing privoxy to tor ! Exiting..."
	exit 1
fi
cat $PRIVOXY_CONFIG | sed -e ${THISLINENO}s/.*/###NOTOR/ >/tmp/pcconfig
cp -f /tmp/pcconfig $PRIVOXY_CONFIG
rm -f /tmp/pcconfig
systemctl start privoxy
