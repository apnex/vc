#!/bin/sh

function start {
	ln -s /root/dnsctl-rec-add.js /usr/sbin/rec-add
	ln -s /root/dnsctl-rec-del.js /usr/sbin/rec-del
	ln -s /root/dnsctl-zone-add.js /usr/sbin/zone-add
	ln -s /root/dnsctl-zone-del.js /usr/sbin/zone-del
	ln -s /root/dnsctl-list.js /usr/sbin/list
	ln -s /root/dnsctl-load.js /usr/sbin/load
	ln -s /root/help.sh /usr/sbin/help
	/usr/sbin/named
	sleep 1
	/root/dnsctl-zone-add.js lab 172.16.0.10
	sleep 1
	load zones.json
	tail -f /var/log/named.log
}

function shell {
	/bin/sh
}

if [ -z "$1" ]
then
	start
else
	case $1 in
		shell)
			shell
		;;
		*)
			start
		;;
	esac
fi
