FROM ubuntu:18.04 AS base

MAINTAINER Brian Ball brian.ball@nrel.gov

# install locales and set to en_US.UTF-8. This is needed for running the CLI on some machines
# such as singularity.
RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  autoconf \
  libssl-dev \
  libicu-dev \
  ninja-build \
  python3.7-dev \
  python3-pip \
  sudo \
  wget \
  bsdtar \
  software-properties-common

RUN apt-add-repository ppa:brightbox/ruby-ng && \
    apt-get update && \
    apt-get install -y ruby2.5 ruby2.5-dev

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
RUN update-alternatives --set python /usr/bin/python3.7
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN python -m pip install --upgrade pip
RUN pip install conan setuptools wheel twine requests packaging
#RUN pip3 install conan

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

#use branch python_measure 
RUN cd /usr/local/src && \
    mkdir openstudio && \
	cd openstudio && \
    git clone https://github.com/NREL/OpenStudio.git . && \
	git checkout python-measure-dynamic && \
	mkdir build && \
	cd build
#	cmake -G Ninja -DDYNAMIC_OPENSTUDIO=ON -DCMAKE_BUILD_TYPE=Release -DCPACK_BINARY_DEB=ON -DCPACK_SOURCE_ZIP=OFF -DBUILD_PYTHON_BINDINGS=ON -DBUILD_PYTHON_PIP_PACKAGE=ON -DBUILD_TESTING=OFF -DBUILD_RUBY_BINDINGS=ON -DBUILD_CLI=ON ../.
#RUN cd /usr/local/src/openstudio/build && \
#	ninja; exit 0 && \
#    ninja; exit 0 && \
#    ninja
#RUN cd /usr/local/src/openstudio/build && \
#    ninja; exit 0
#	ninja package && \
#    ninja_python_package
	
CMD [ "/bin/bash" ]
