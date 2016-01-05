FROM centos:7.1.1503
# Populated by mkovs_tarball.sh
ENV OVS_VERSION
# Workaround build warning related to 'tput'.
ENV TERM dumb
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
# Update Centos and install dependencies
RUN yum update -y
RUN yum remove -y fakesystemd
RUN yum install -y git wget kernel openssl openssl-devel kernel-devel kernel-headers \
		   rpm-build redhat-rpm-config fuse fuse-devel gcc make python-devel graphviz \
   	           kernel-debug-devel autoconf automake rpm-build redhat-rpm-config \
   		   libtool
# Let's make wget output a bit less verbose.
RUN echo progress = dot:mega > /.wgetrc
RUN wget http://openvswitch.org/releases/openvswitch-$OVS_VERSION.tar.gz
RUN tar -zxf openvswitch-$OVS_VERSION.tar.gz && \
	rm openvswitch-$OVS_VERSION.tar.gz
COPY dpdk/ /dpdk
# This symlink is because WORKDIR doesn't expand $VARS.
WORKDIR /
RUN ln -s openvswitch-$OVS_VERSION openvswitch
WORKDIR /openvswitch
RUN mkdir build && \
	mkdir build/output && \
	mkdir build/output/install && \
	mkdir build/output/images
ADD build_tarball.sh /opt/
ADD ovs-patch/ /openvswitch/
# Following patches only apply to 2.4.0
# In other cases we don't care about failure to apply
RUN patch -p1 | cat patches || return 0
RUN /opt/build_tarball.sh
RUN ln -s /openvswitch/build/output/images/openvswitch-$OVS_VERSION-dpdk.tar.gz /openvswitch-$OVS_VERSION-dpdk.tar.gz
