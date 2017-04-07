FROM ubuntu:14.04
MAINTAINER Nandan Bharadwaj <nandan07bharadwaj@gmail.com>

RUN apt-get update
RUN apt-get install -qy --no-install-recommends telnet build-essential gawk wget texinfo supervisor iptables tcpdump net-tools

# Patch Quagga to support FPM
ADD fpm-remote.diff?version=1 /tmp/fpm_patchfile.diff
ADD zebra.conf /root/zebra.conf
RUN wget http://download.savannah.gnu.org/releases/quagga/quagga-0.99.23.tar.gz
RUN tar zxvf quagga-0.99.23.tar.gz
WORKDIR /quagga-0.99.23
RUN patch -p1 < /tmp/fpm_patchfile.diff
RUN ./configure --enable-fpm --prefix=/usr
RUN make
RUN make install

# 2601/tcp - zebra management port
EXPOSE 2601
