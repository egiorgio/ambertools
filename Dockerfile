# docker build -t ubuntu_ambertools_serialbuild_ssh .

FROM ubuntu:14.04

MAINTAINER Emidio Giorgio <emidio.giorgio@ct.infn.it>

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade
    
RUN apt-get -y install \
      bison \
      build-essential \
      cloud-init \
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
      openssh-server \
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
ADD prova_amber.tgz /usr/local
ENV PATH=$PATH:/usr/lib64/openmpi/bin/
ENV AMBERHOME=/usr/local/amber14
RUN cd $AMBERHOME && ./configure -noX11 gnu && make install
RUN cd $AMBERHOME && ./configure -mpi -noX11 gnu && make install

RUN mkdir -p /var/run/sshd
# set a root password, in case cloud-init doesn't work 
RUN echo 'root:c@r0nt3' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# enable sshd on 2222 port
RUN sed -i 's/Port 22/Port 22\nPort 2222/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# if dns server is not injected
RUN echo "nameserver 193.206.208.78" >> /etc/resolv.conf

# clean cloud-init stuff
RUN rm -fr /var/lib/cloud/*
# not really used
RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN echo "export AMBERHOME=/usr/local/amber14" >> /etc/profile

# let know what we require
EXPOSE 22
EXPOSE 2222
CMD /usr/bin/cloud-init init && /usr/sbin/sshd -D
