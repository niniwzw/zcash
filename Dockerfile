FROM ubuntu:14.04
MAINTAINER King Wang <james@example.com>
ENV REFRESHED_AT 2016-08-16


RUN apt-get -yqq update
RUN apt-get -yqq install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake
#RUN git clone https://github.com/zcash/zcash.git .

#RUN apt-get -yqq install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev

COPY . /opt
ENV DATA_ROOT /root/.zcash
RUN mkdir -p $DATA_ROOT
WORKDIR /opt
RUN echo "addnode=mainnet.z.cash" > ~/.zcash/zcash.conf
RUN echo "rpcuser=username" >> ~/.zcash/zcash.conf
RUN echo "rpcpassword=`head -c 32 /dev/urandom | base64`" >> ~/.zcash/zcash.conf
RUN echo 'gen=1' >> ~/.zcash/zcash.conf
RUN echo "genproclimit=$(nproc)" >> ~/.zcash/zcash.conf
RUN echo 'equihashsolver=tromp' >> ~/.zcash/zcash.conf

RUN ./zcutil/build.sh -j$(nproc)
RUN ./zcutil/fetch-params.sh

VOLUME $DATA_ROOT



EXPOSE 8232
EXPOSE 8233

CMD ["./src/zcashd"]
