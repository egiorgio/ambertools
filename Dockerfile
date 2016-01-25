# docker build -t ubuntu_ambertools .

FROM ubuntu:14.04

MAINTAINER Mario David <mariojmdavid@gmail.com>

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade
    
RUN apt-get -y install \
      bison \
      build-essential \
      cmake \
      csh \
      cython \
      flex \
      g++ \
      gfortran \
      git \
      libbz2-dev \
      libfreetype6-dev \
      liblapack-dev \
      libatlas-dev \
      libopenmpi-dev \
      openmpi-bin \
      openmpi-common \
      patch  \
      python-dev \
      python-matplotlib \
      python-pip \
      python-tk \
      time \
      wget

RUN pip install --upgrade pip
RUN pip install mako
RUN pip install numpy
RUN pip install scipy
ADD AmberTools15.tar.bz2 /usr/local/
ENV PATH=$PATH:/usr/lib64/openmpi/bin/
ENV AMBERHOME=/usr/local/amber14
RUN cd $AMBERHOME && ./configure -mpi -noX11 gnu && make install

