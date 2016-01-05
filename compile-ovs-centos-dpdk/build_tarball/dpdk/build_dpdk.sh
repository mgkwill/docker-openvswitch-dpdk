#!/bin/bash

export DPDK_VERSION='2.2.0'
echo    "-------> WGET DPDK version -- dpdk-$DPDK_VERSION.tar.gz "
wget http://dpdk.org/browse/dpdk/snapshot/dpdk-$DPDK_VERSION.tar.gz
echo    "-------> Untaring DPDK -- tar -xvzpf dpdk-$DPDK_VERSION.tar.gz "
tar -xvzpf dpdk-$DPDK_VERSION.tar.gz && \
        rm dpdk-$DPDK_VERSION.tar.gz
echo    "-------> Creating DPDK DIR structure ----- "
ln -s dpdk-$DPDK_VERSION dpdk-build
cd dpdk-build
mkdir build && \
        mkdir build/output && \
        mkdir build/output/install && \
        mkdir build/output/images
echo    "-------> Copying and Applying DPDK patches -- $(cat ../dpdk-patch/patches) --"
cp ../dpdk-patch/config.2.2.0.patch .
patch config/common_linuxapp config.2.2.0.patch || return 0
echo    "-------> Building DPDK -- make DESTDIR='build/output/install' install T=x86_64-ivshmem-linuxapp-gcc"
make install T=x86_64-ivshmem-linuxapp-gcc DESTDIR='/vagrant/build_tarball/dpdk/dpdk-build/build/output/install'
