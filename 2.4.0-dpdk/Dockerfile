FROM centos:7.1.1503
MAINTAINER OpenDaylight OVSDB Project Team <ovsdb-dev@lists.opendaylight.org>
ENV OVS_VERSION 2.4.0
ENV SUPERVISOR_STDOUT_VERSION 0.1.1
RUN yum update -y
RUN yum install -y wget tar python-setuptools && yum clean all 
# Install supervisor
RUN easy_install pip && pip install supervisor
# Configure supervisord
RUN mkdir -p /var/log/supervisor/
ADD supervisord.conf /etc/
# Install supervisor_stdout
WORKDIR /opt
RUN mkdir -p /var/log/supervisor/
RUN mkdir -p /etc/openvswitch
RUN wget https://pypi.python.org/packages/source/s/supervisor-stdout/supervisor-stdout-$SUPERVISOR_STDOUT_VERSION.tar.gz --no-check-certificate && \
	tar -xzvf supervisor-stdout-0.1.1.tar.gz && \
	mv supervisor-stdout-$SUPERVISOR_STDOUT_VERSION supervisor-stdout && \
	rm supervisor-stdout-0.1.1.tar.gz && \
	cd supervisor-stdout && \
	python setup.py install -q
# Setup DPDK Support
#COPY dpdk-tools-2.0-tip.tar.gz \
#RUN mkdir -p dpdk && tar -xzvf dpdk-tools-2.0.tar.gz -C /opt/dpdk &&\
#        rm dpdk-tools-2.0.tar.gz
#        echo 8192 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages &&\
#        mount -t hugetlbfs nodev /dev/hugepages &&\
#        modprobe uio
#        insmod /opt/dpdk/kmod/igb_uio.ko
# Get Open vSwitch
WORKDIR /
COPY openvswitch-$OVS_VERSION-dpdk.tar.gz /
RUN tar -xzvf openvswitch-$OVS_VERSION-dpdk.tar.gz &&\
        rm openvswitch-$OVS_VERSION-dpdk.tar.gz
ADD configure-ovs.sh /usr/local/share/openvswitch/
# Create the database
RUN ovsdb-tool create /etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema
# Put the OVS Python modules on the Python Path
RUN cp -r /usr/local/share/openvswitch/python/ovs /usr/lib/python2.7/site-packages/ovs
CMD ["/usr/bin/supervisord"]
