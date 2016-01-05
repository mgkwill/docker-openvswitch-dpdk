# docker-openvswitch-dpdk
h1. Docker Container Openvswith w/ DPDK 

Open vswitch enabled with dpdk docker container for testing developement purposes.

h5. Requirements
	Requires: 
	* docker
	* dev tools required to build DPDK and Open vSwitch -See appropriate docs

h5. Makefile not currently functional
Follow instructions to compile OVS and build docker container below.

h4. Compile OVS 
OVS must be compiled to tar.gz and copied into docker directory before build.

* compile-ovs-alpine - does not currently support DPDK
* compile-ovs-centos-dpdk - DPDK support exerimental

Goto either of above directories:
	cd compile-ovs-alpine
and run 
	mkovs_tarball.sh 2.4.0
After openvswitch-2.4.0.tar.gz or openvswitch-2.4.0-dkdp.tar.gz is created
copy it to appropriate docker container directory:
	cp openvswitch-2.4.0.tar.gz ../2.4.0/.
	cp openvswitch-2.4.0-dkdp.tar.gz ../2.4.0-dpdk/.

h4. Build OVS Docker Container
Go to appropriate docker container directory
	cd 2.4.0
	docker build -t mgkwill/openvswitch:2.4.0 .
You can update supervisord.conf or configure-ovs.sh and recompile to 
change behavior of ovs docker container.
