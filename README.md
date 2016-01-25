# docker-ambertools

## Introduction
The docker image is Ubuntu 14.04 LTS with AmberTools v15 compiled with openmpi

## Pre condictions
This step has to be done before building the image since you have to register.
Download AmberTools from http://ambermd.org/AmberTools15-get.html

Clone the repository and move AmberTools15.tar.bz2 to the dir containing the Dockerfile
```
$ git clone git@github.com:LIP-Computing/docker-ambertools.git
$ mv AmberTools15.tar.bz2 docker-ambertools/
```

## Build the docker image

```
$ docker build -t ubuntu_ambertools .
```

## Run the tests

The example below will run the test from within the docker container.

```
$ docker run -it ubuntu_ambertools /bin/bash
# cd $AMBERHOME
# export DO_PARALLEL='mpirun -np 4'
# source /usr/local/amber14/amber.sh
# make test.parallel
```

Alternatively, run the tests directly:
```
$ docker run ubuntu_ambertools /bin/bash -c \
'cd $AMBERHOME && export DO_PARALLEL="mpirun -np 4" && source $AMBERHOME/amber.sh && make test.parallel'
```
