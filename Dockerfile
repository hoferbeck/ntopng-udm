FROM arm32v7/debian:11

COPY entrypoint.sh /entrypoint.sh
#COPY packages/*220520*.deb /tmp/
#COPY packages/ntop-license_1.0_amd64.deb /tmp/
#COPY packages/pfring_8.0.0-7466_amd64.deb /tmp/


RUN apt-get update && \
    apt-get -y -q install sudo apt-utils && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get -y -q install curl lsb-release gnupg net-tools libterm-readline-gnu-perl netcat && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L http://packages.ntop.org/apt/ntop.key | apt-key add -

RUN echo "deb http://apt.ntop.org/stretch_pi armhf/" > /etc/apt/sources.list.d/ntop.list && \
    echo "deb http://apt.ntop.org/stretch_pi all/" >> /etc/apt/sources.list.d/ntop.list

RUN groupadd -g 998 -r ntopng && useradd --no-log-init -u 998 -r -g ntopng ntopng


RUN apt-get update && apt-get --no-install-recommends -y install libsqlite3-0 libexpat1 redis-server librrd8 logrotate libcurl4 libpcap0.8 libldap-2.4-2 libhiredis0.14 \
            libssl1.1 libmariadbd19 lsb-release tar ethtool libcap2 bridge-utils libnetfilter-conntrack3 libzstd1 libmaxminddb0 \
            libradcli4 libjson-c3 libsnmp30 udev libzmq5 libcurl3-gnutls net-tools curl procps libnetfilter-queue1 whiptail libnuma1 ntopng && rm -rf /var/lib/apt/lists/* \
        && curl -Lo /tmp/geoipupdate_2.3.1-1_arm64.deb  http://ftp.us.debian.org/debian/pool/contrib/g/geoipupdate/geoipupdate_2.3.1-1_arm64.deb \
        # && dpkg -i /tmp/*.deb && rm /tmp/*.deb \
        && echo "-i=br0\n-n=1\n-W=3001" >> /etc/ntopng/ntopng.conf && chmod +x /entrypoint.sh



RUN chown -R ntopng:ntopng /var/lib/ntopng

ENTRYPOINT ["/entrypoint.sh"]
