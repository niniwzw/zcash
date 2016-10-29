FROM ubuntu:16.04
MAINTAINER King Wang <james@example.com>
ENV REFRESHED_AT 2016-08-16

COPY . /opt
RUN apt-get -yqq update
RUN apt-get -yqq install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake
#RUN git clone https://github.com/zcash/zcash.git .
WORKDIR /opt
RUN ls -lh
RUN git checkout v1.0.0
RUN ./zcutil/fetch-params.sh
RUN ./zcutil/build.sh -j$(nproc)

RUN mkdir -p ~/.zcash
RUN echo "addnode=mainnet.z.cash" >~/.zcash/zcash.conf
RUN echo "rpcuser=username" >>~/.zcash/zcash.conf
RUN echo "rpcpassword=`head -c 32 /dev/urandom | base64`" >>~/.zcash/zcash.conf
RUN echo 'gen=1' >> ~/.zcash/zcash.conf
RUN echo "genproclimit=$(nproc)" >> ~/.zcash/zcash.conf
RUN echo 'equihashsolver=tromp' >> ~/.zcash/zcash.conf

CMD ["./src/zcashd"]
