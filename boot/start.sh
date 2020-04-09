#!/bin/bash
echo "-- shutting down running containers --"
docker rm -f -v $(docker ps -q) 2>/dev/null
echo "-- removing untagged containers --"
docker rmi -f $(docker images -q --filter dangling=true) 2>/dev/null
echo "-- removing orphaned volumes --"
docker rm -f $(docker ps -qa -f status=exited) 2>/dev/null

echo "-- starting constellation --"
	#-v ${PWD}/zones.json:/root/zones.json \
docker run -d -P --net host --restart=unless-stopped \
	--name dns apnex/control-dns
docker run -d -P --net host \
	-v ${PWD}/dhcpd.conf:/etc/dhcpd.conf \
	--name pxe apnex/control-pxe
docker run -d -p 5081:80 --name node-esx apnex/node-esx
docker run -d -p 5082:80 --name node-centos apnex/node-centos
docker run --name squid -d -p 3128:3128 \
	-v ${PWD}/entrypoint.sh:/sbin/entrypoint.sh \
	-v ${PWD}/squid.conf:/etc/squid3/squid.conf \
	-v ${PWD}/cache:/var/spool/squid3 \
	apnex/control-squid
docker ps
