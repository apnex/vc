### pxe boot nuc into esx
log into IP: 172.16.0.11

### deploy vc via cli
./vcenter.create.sh

### initial vc config
create datacenter `sddc`
create cluster `mgmt`
add host `sddc.lab`

### verify morefs
vsp host.list
vsp network.list
vsp datastore.list
vsp folder.list

### stand up centos boot vm
vsp vm.create spec.vm.boot.json

### import centos.iso
create local content-local
import item from URL: http://pxe.apnex.io/centos.io

### mark boot order DISK before ETHERNET
vsp vm.list
vsp vm.boot.list vm-14
vsp vm.boot.order vm-14
vsp vm.boot.list vm-14

### view centos.iso library item
./drv.library.list.sh
./drv.library.item.list.sh c643931b-e3d9-456c-be6f-ade1286a4cf9
./drv.library.file.list.sh 5a038385-0e68-4a14-b3d7-73d3537536bf

### mount centos.iso to vm
vsp vm.list
./drv.vm.iso.mount.sh 5a038385-0e68-4a14-b3d7-73d3537536bf vm-14
vsp vm.start vm-14

### update eth0 network on VM
TYPE=Ethernet
BOOTPROTO=none
NAME=eth0
DEVICE=eth0
ONBOOT=yes
IPADDR=172.16.0.1
GATEWAY=172.16.0.10
PREFIX=24

### install and enable docker
yum -y update
yum -y install docker
systemctl enable docker
systemctl start docker

## start services
/root/start.sh

## set boot.lab to Auto Startup with VC
configure this on HOST > CONFIGURE > VMS

### configure VC dns to point to 172.16.0.1
### ensure VC time sync to host
### configure host NTP enable and sync: pool.ntp.org

## Configure VDS fabric
set mtu to 9000

## add fabric to host (sddc.lab)
## create fabric port-groups
pg-mgmt: vlan 10
pg-vmotion: vlan 11
pg-uplink: vlan 5

## create vmk
vmk1: pg-vmotion

## add 2 new nics to boot.lab
eth1: pg-mgmt
eth2: pg-uplink

### update eth1 network on boot.lab
TYPE=Ethernet
BOOTPROTO=none
NAME=eth1
DEVICE=eth1
ONBOOT=yes
IPADDR=172.16.10.1
PREFIX=24

### update eth0 network on boot.lab
TYPE=Ethernet
BOOTPROTO=none
NAME=eth2
DEVICE=eth2
ONBOOT=yes
IPADDR=172.16.5.1
PREFIX=24

### start all services on boot.lab
/sbin/sysctl -w net.ipv4.ip_forward=1
/root/start.sh

### build esx01.lab
vsp vm.create spec.esx01.json

### start esx01.lab
# vm will start and pxe into esx
vsp vm.start <vm.id>

### shutdown vm and connect nics
vnic1: pg-mgmt
vnic2: pg-trunk

### build cluster 'cmp'

### WORKFLOW: Enable nested ESX
vsp vm.start <vm.id>

#### create cmp datastore
ds-esx01

#### create logs dir on DS
[ds-esx01]/logs
Advanced System Settings: Syslog.global.logDir = [ds-esx01]/logs

#### set services
ntp: Start with host: pool.ntp.org

#### attach VDS
Assign vmnic0 to uplink1
Assign vmk0 to pg-mgmt

### WORKFLOW: Deploy HCX
./deploy-hcx-manager.sh

### remove mem reservation and power on
minimum 8GB (didnt boot correctly with 4GB)

### activate HCX manager
enter Enterprise activation key
initial location and base configuration
connection to vc

### lookup service (hcx manager)
https://vcenter.lab:443/lookupservice/sdk

### restart services
### log into vsphere-client (flash)

### Workflow: Deploy NSX
./deploy-manager.sh

#### Set mem
- Adjust to 4096
- Clear mem reservations

#### Power on
vsp vm.start <vm.id>

### WORKFLOW: Switch NUC to VDS
#### VC Advanced Settings
config.vpxd.network.rollback: true
####
