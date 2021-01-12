#!/bin/bash

ovftool \
	"vi://administrator@vsphere.local:VMware1!SDDC@vcenter.lab01:443/lab01/vm/labops" \
	labops.ova
