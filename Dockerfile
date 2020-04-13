FROM ubuntu:18.04 AS base

MAINTAINER Brian Ball brian.ball@nrel.gov

# install locales and set to en_US.UTF-8. This is needed for running the CLI on some machines
# such as singularity.
RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  autoconf \
  libssl-dev \
  ninja-build \
  python3-dev \
  python3-pip \ 
  sudo \
  wget \
  bsdtar \
  software-properties-common

RUN apt-add-repository ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get install -y ruby2.5 ruby2.5-dev
	
RUN pip3 install conan

ARG CMAKE_VERSION=3.17.1
RUN cd /usr/local/src/ && \
    mkdir cmake && \
	cd cmake && \
	wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz && \
	bsdtar --strip-components=1 -xvf cmake-$CMAKE_VERSION.tar.gz && \
	./bootstrap && \
	make -j$(nproc) && \
	make install && \
	ln -s /usr/local/bin/cmake /usr/bin/cmake

RUN cd /usr/local/src && \
    mkdir openstudio && \
	cd openstudio && \
    git clone https://github.com/NREL/OpenStudio.git . && \
	git checkout pmeasure && \
	mkdir build && \
	cd build && \
	cmake -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF -DBUILD_PACKAGE=ON -DCPACK_BINARY_IFW=OFF -DCPACK_BINARY_NSIS=OFF -DCPACK_BINARY_RPM=OFF -DCPACK_BINARY_STGZ=OFF -DCPACK_BINARY_TBZ2=OFF -DCPACK_BINARY_TXZ=OFF -DCPACK_BINARY_TZ=OFF -DCPACK_BINARY_TGZ=OFF -DCPACK_BINARY_DEB=ON -DCPACK_SOURCE_RPM=OFF -DCPACK_SOURCE_TBZ2=OFF -DCPACK_SOURCE_TGZ=OFF -DCPACK_SOURCE_TXZ=OFF -DCPACK_SOURCE_TZ=OFF -DCPACK_SOURCE_ZIP=OFF ../. && \
	ninja
CMD [ "/bin/bash" ]
