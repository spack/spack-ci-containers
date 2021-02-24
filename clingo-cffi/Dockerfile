FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    SPACK_TEST_SOLVER=clingo 

RUN apt-get -yqq update \
 && apt-get -yqq install --no-install-recommends \
        build-essential \
        curl \
        file \
        g++ \
        gcc \
        gfortran \
        git \
	subversion \
        gnupg2 \
        make \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        tcl \
        unzip \
        locales \
        patchelf \
        mercurial \
 && locale-gen en_US.UTF-8 \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install -U pip cffi coverage && pip3 install -i https://test.pypi.org/simple/ clingo-cffi
