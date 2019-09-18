FROM ubuntu:18.04 as build
ENV BUILD_PACKAGES="build-essential git llvm-3.9-dev libclang-3.9-dev clang-3.9 cmake libssl-dev pkg-config jq curl"
RUN apt-get update && \
  apt-get install -y $BUILD_PACKAGES
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN /bin/bash -c "source $HOME/.cargo/env && \
  rustup install nightly-2019-08-05 && \
  rustup default nightly-2019-08-05 && \
  rustup component add rustfmt-preview"
RUN git clone https://github.com/KomodoPlatform/atomicDEX-API --branch mm2 --single-branch 
RUN cd atomicDEX-API && /bin/bash -c "source $HOME/.cargo/env && cargo build --features native -vv"


#RUN cd /atomicDEX-API/target/debug && wget https://raw.githubusercontent.com/jl777/coins/master/coins
#CMD ["/bin/bash"] 

#RUN rustup install nightly-2019-06-26
#RUN rustup default nightly-2019-06-26
#RUN rustup component add rustfmt-preview

FROM ubuntu:18.04
RUN apt-get update && \
  apt-get install -y git jq wget curl nano openssh-server ngrep tmux net-tools 
#RUN git clone https://github.com/KomodoPlatform/atomicDEX-API --branch mm2 --single-branch 
#RUN mkdir -p /atomicDEX-API/target/debug && cd /atomicDEX-API/target/debug && wget https://raw.githubusercontent.com/jl777/coins/master/coins
RUN cd /usr/local/bin && wget https://raw.githubusercontent.com/jl777/coins/master/coins
COPY --from=build /atomicDEX-API/target/debug/mm2 /usr/local/bin
COPY /scripts/* /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
RUN apt-get update && apt-get install -y build-essential gcc-8 g++-8 libcurl4-gnutls-dev curl
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8
RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.3/cmake-3.15.3.tar.gz && \
  tar zxvf cmake-3.15.3.tar.gz && \
  cd cmake-3.15.3/ && \
  ./configure && \
  make && \
  make install && \
  update-alternatives --install /usr/bin/cmake cmake /usr/local/bin/cmake 1 --force
RUN git clone https://github.com/KomodoPlatform/antara-makerbot.git && \
  cd antara-makerbot/ && \
  mkdir build && \
  cd build/ 
#&& \
#  cmake -DCMAKE_BUILD_TYPE=Release ../ 
# && \
#  cmake --build . --target mmbot --config Release 
CMD ["/usr/local/bin/entrypoint.sh"] 
