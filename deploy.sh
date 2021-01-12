#!/bin/bash

USERNAME='administrator@vsphere.local'
PASSWORD='VMware1!SDDC'
VCENTER='vcenter.lab01'
VCPATH='/lab01/host/cmp'
TARGET="vi://${USERNAME}:${PASSWORD}@${VCENTER}:443${VCPATH}"

echo "${TARGET}"
ovftool \
	--name=labops \
	--allowExtraConfig \
	--datastore=vsanDatastore \
	--network="pg-mgmt" \
	--acceptAllEulas \
	--noSSLVerify \
	--diskMode=thin \
labops.ova \
"${TARGET}"
