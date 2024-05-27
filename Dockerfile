FROM ubuntu:20.04

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata
RUN apt install -y curl wget git build-essential software-properties-common
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt update

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN apt install -y nodejs

RUN apt install -y gcc-7 gcc-8 gcc-9 gcc-10 gcc-11

RUN apt install -y g++-7 g++-8 g++-9 g++-10 g++-11

RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 9
RUN ./llvm.sh 10
RUN ./llvm.sh 11
RUN ./llvm.sh 12
RUN ./llvm.sh 13
RUN ./llvm.sh 14

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

RUN git clone https://github.com/compiler-explorer/compiler-explorer /opt/compiler-explorer
RUN rm -rf /opt/compiler-explorer/etc/config/*.properties
COPY configs/* /opt/compiler-explorer/etc/config/
RUN cd /opt/compiler-explorer && npm install && make prebuild

COPY config.yml /opt/config.yml
COPY setup_crates.sh /opt/setup_crates.sh
RUN cd /opt && sh setup_crates.sh && rm -rf tmp

WORKDIR /opt/compiler-explorer
ENTRYPOINT [ "make" ]
