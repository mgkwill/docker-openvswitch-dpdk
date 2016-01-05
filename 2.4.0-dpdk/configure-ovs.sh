#!/bin/sh
# DPDK Boot Configuration 
mount -t hugetlbfs -o pagesize=1G none /dev/hugepages

echo 8192 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
mkdir /mnt/huge
mount -t hugetlbfs nodev /mnt/huge

modprobe uio 

#DPDK_HOME=/dpdk-2.2.0
# insmod $(DPDK_HOME)/lib/librte_vhost/eventfd_link/eventfd_link.ko
#insmod $(DPDK_HOME)/x86_64-ivshmem-linuxapp-gcc/kmod/igb_uio.ko

#$(DPDK_HOME)/tools/dpdk_nic_bind.py --bind=igb_uio eth0
#$(DPDK_HOME)/tools/dpdk_nic_bind.py --status

# OVS Config

ovs_version=$(ovs-vsctl -V | grep ovs-vsctl | awk '{print $4}')
ovs_db_version=$(ovsdb-tool schema-version /usr/local/share/openvswitch/vswitch.ovsschema)

# give ovsdb-server and vswitchd some space...
sleep 3
# begin configuring
ovs-vsctl --no-wait -- init
ovs-vsctl --no-wait -- set Open_vSwitch . db-version="${ovs_db_version}"
ovs-vsctl --no-wait -- set Open_vSwitch . ovs-version="${ovs_version}"
ovs-vsctl --no-wait -- set Open_vSwitch . system-type="docker-ovs"
ovs-vsctl --no-wait -- set Open_vSwitch . system-version="0.1"
ovs-vsctl --no-wait -- set Open_vSwitch . external-ids:system-id=`cat /proc/sys/kernel/random/uuid`
ovs-vsctl --no-wait -- set-manager ptcp:6640
ovs-appctl -t ovsdb-server ovsdb-server/add-remote db:Open_vSwitch,Open_vSwitch,manager_options

ovs-vsctl add-br br0 -- set bridge br0 datapath_type=netdev
ovs-vsctl add-port br0 dpdk0 -- set Interface dpdk0 type=dpdk
