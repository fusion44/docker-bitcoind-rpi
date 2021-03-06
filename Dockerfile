FROM resin/rpi-raspbian
MAINTAINER Stefan Stammberger <some.fusion@gmail.com>

RUN apt-get update && sudo apt-get upgrade -y
RUN apt-get install wget -y

WORKDIR /tmp

RUN wget https://bitcoin.org/bin/bitcoin-core-0.16.1/bitcoin-0.16.1-arm-linux-gnueabihf.tar.gz && \
    wget https://bitcoin.org/bin/bitcoin-core-0.16.1/SHA256SUMS.asc && \
    wget https://bitcoin.org/laanwj-releases.asc

# RUN sha256sum --check SHA256SUMS.asc

RUN if sha256sum --check SHA256SUMS.asc | grep 'bitcoin-0.16.1-arm-linux-gnueabihf.tar.gz: OK'; then exit 0; fi
RUN gpg laanwj-releases.asc

RUN gpg --import laanwj-releases.asc
RUN gpg --verify SHA256SUMS.asc

RUN tar -xvf bitcoin-0.16.1-arm-linux-gnueabihf.tar.gz
RUN sudo install -m 0755 -o root -g root -t /usr/local/bin bitcoin-0.16.1/bin/*
RUN bitcoind --version

ENV HOME /bitcoin

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

VOLUME ["/bitcoin"]
EXPOSE 8332 8333
WORKDIR /bitcoin

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
