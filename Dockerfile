FROM ubuntu:16.04

ARG e2cid
ARG installcode

USER root
# Copy the scripts into the docker instance
COPY sysprep.sh  /tmp/
COPY install.sh  /tmp/
COPY easy2connect /bin/
COPY easy2connectrefresh /bin/

# Install required packages and run scripts
RUN apt-get -yqq update \
    && apt-get -yqq install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common \
	psmisc iptables openssl curl pgp openvpn zip knockd dnsutils easy-rsa wget libterm-readline-gnu-perl \
    && cd /tmp/ \
    && chmod 777 /tmp/sysprep.sh \
    && chmod 777 /tmp/install.sh \
    && chmod 755 /bin/easy2connect \
    && chmod 755 /bin/easy2connectrefresh \
    && /tmp/sysprep.sh \
    && /tmp/install.sh 

# This is just a hack, since the scripts try to determine the Linux version from /etc/issue.net, but fail
COPY issue.net /etc/issue.net
    
CMD nohup bash -c "/bin/easy2connect"

