#!/bin/bash

MAXTRIES=2

function torcheck()
{
    local  myresult='1'
    curl --socks5-hostname localhost:9050 -s -o /dev/null https://check.torproject.org/
    myresult=$?
    echo "$myresult"
}

ps ax | grep torrc | head -1 | grep -v grep >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "torcheck:disabled:nocircuit"
	exit 0
fi
COUNTER=0
while [  $COUNTER -lt $MAXTRIES ]; do
	result=$(torcheck)
	if [ $result -eq 0 ]; then
		break
	fi
	let COUNTER=COUNTER+1 
done
if [ $result -eq 0 ]; then
	echo "torcheck:enabled:circuit"
	exit 0
else
	echo "torcheck:enabled:nocircuit"
	exit 0
fi
