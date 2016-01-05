#!/bin/bash

# Script Config Options
# Set OVS_VERSION in Environment
# OVS_VERSION
DPDK_DIR="/dpdk"
DPDK_BUILD="$DPDK_DIR/x86_64-ivshmem-linuxapp-gcc/"
OVS_BUILD_DEST_DIR="/openvswitch/build"
OVS_BUILD_INSTALL_DIR="$OVS_BUILD_DEST_DIR/output/install"
OVS_TAR_DEST_DIR="$OVS_BUILD_DEST_DIR/output/images"
OVS_FILE_LST_DEST_DIR="$OVS_BUILD_DEST_DIR/ovs-build-files$OVS_VERSION.lst"
OVS_CONFIG_OPTIONS="--with-dpdk=$DPDK_BUILD [CFLAGS="-g -O2"]"

# Script Actions
echo	"-------> Configuring OVS Build with -- $OVS_CONFIG_OPTIONS "
./configure $OVS_CONFIG_OPTIONS
echo	"-------> Cleaning OVS Build DIR "
make clean
echo	"-------> Building OVS with -- $CONFIG_OPTIONS "
make
echo	"-------> Installing OVS Build to -- $TAR_DEST_DIR "
make DESTDIR=$OVS_BUILD_INSTALL_DIR install
echo	"-------> Creating OVS Build file list at -- $FILE_LST_DEST_DIR "
cd $OVS_BUILD_INSTALL_DIR
find . -type f -print > $OVS_FILE_LST_DEST_DIR
echo	"-------> Creating OVS Build tarball -- $OVS_TAR_DEST_DIR/openvswitch-$OVS_VERSION-dpdk.tar.gz "
ls -al $OVS_TAR_DEST_DIR/
tar zcvf $OVS_TAR_DEST_DIR/openvswitch-$OVS_VERSION-dpdk.tar.gz `cat $OVS_FILE_LST_DEST_DIR`
