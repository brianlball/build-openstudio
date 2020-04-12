FROM ubuntu:18.04 AS base

MAINTAINER Brian Ball brian.ball@nrel.gov

#remove existing cmake
#RUN apt remove --purge --auto-remove cmake

# install locales and set to en_US.UTF-8. This is needed for running the CLI on some machines
# such as singularity.
RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  libssl-dev \
  libxt-dev \
  libncurses5-dev \
  libgl1-mesa-dev \
  autoconf \
  libexpat1-dev \
  libpng-dev \
  libfreetype6-dev \
  libdbus-glib-1-dev \
  libglib2.0-dev \
  libfontconfig1-dev \
  libxi-dev \
  libxrender-dev \
  libgeographic-dev \
  libicu-dev \
  chrpath \
  bison \
  libffi-dev \
  libgdbm-dev \
  libqdbm-dev \
  libreadline-dev \
  libyaml-dev \
  libharfbuzz-dev \
  libgmp-dev \
  patchelf \
  python-pip \
  libx11-dev \
  libxext-dev \
  libxfixes-dev \
  libxcb1-dev \
  libx11-xcb-dev \
  libxcb-glx0-dev \
  libdrm-dev \
  libxcomposite-dev \
  libxcursor-dev \
  libxrandr-dev \
  libxtst-dev \
  libdbus-1-dev \
  libfontconfig-dev \
  libnss3-dev \
  libatspi2.0-dev \
  python \
  flex \
  gperf \
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

RUN cd /usr/local/src/ && \
    mkdir cmake && \
	cd cmake && \
    wget https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz && \
	bsdtar --strip-components=1 -xvf cmake-3.15.2.tar.gz && \
	./bootstrap && \
	make && \
	make install && \
	ln -s /usr/local/bin/cmake /usr/bin/cmake

RUN cd /usr/local/src && \
    mkdir openstudio && \
	cd openstudio && \
    wget https://github.com/NREL/OpenStudio/archive/pmeasure.tar.gz && \
	bsdtar --strip-components=1 -xvf pmeasure.tar.gz && \
	mkdir build && \
	cd build && \
	#cmake -DOPENSSL_INCLUDE_DIR=/usr/bin/openssl -DBUILD_TESTING=ON -DBUILD_DVIEW=ON -DBUILD_OS_APP=ON -DBUILD_PACKAGE=ON -DBUILD_PAT=OFF -DCMAKE_BUILD_TYPE=Release -DCPACK_BINARY_DEB=ON -DCPACK_BINARY_IFW=OFF -DCPACK_BINARY_NSIS=OFF -DCPACK_BINARY_RPM=OFF -DCPACK_BINARY_STGZ=OFF -DCPACK_BINARY_TBZ2=OFF -DCPACK_BINARY_TGZ=OFF -DCPACK_BINARY_TXZ=OFF -DCPACK_BINARY_TZ=OFF ..
	#cmake -DOPENSSL_INCLUDE_DIR=/usr/bin/openssl -DBUILD_TESTING=OFF -DBUILD_DVIEW=OFF -DBUILD_OS_APP=OFF -DBUILD_PACKAGE=ON -DBUILD_PAT=OFF -DCMAKE_BUILD_TYPE=Release -DCPACK_BINARY_DEB=ON -DCPACK_BINARY_IFW=OFF -DCPACK_BINARY_NSIS=OFF -DCPACK_BINARY_RPM=OFF -DCPACK_BINARY_STGZ=OFF -DCPACK_BINARY_TBZ2=OFF -DCPACK_BINARY_TGZ=OFF -DCPACK_BINARY_TXZ=OFF -DCPACK_BINARY_TZ=OFF ..
	make -j16 package && \
	./configure
	
	
CMD [ "/bin/bash" ]
