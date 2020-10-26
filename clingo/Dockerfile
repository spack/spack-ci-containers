# Build stage with Spack pre-installed and ready to be used
FROM spack/ubuntu-bionic:latest as builder

# What we want to install and how we want to install it
# is specified in a manifest file (spack.yaml)
RUN mkdir /opt/spack-environment \
&&  (echo "spack:" \
&&   echo "  specs:" \
&&   echo "  - clingo@develop build_type=Release target=x86_64" \
&&   echo "  - python+optimizations" \
&&   echo "  - py-coverage" \
&&   echo "  concretization: together" \
&&   echo "  config:" \
&&   echo "    install_tree: /opt/software" \
&&   echo "  view: /opt/view") > /opt/spack-environment/spack.yaml

# Install the software, remove unecessary deps
RUN cd /opt/spack-environment && spack env activate . && spack install --fail-fast && spack gc -y

# Strip all the binaries
RUN find -L /opt/view/* -type f -exec readlink -f '{}' \; | \
    xargs file -i | \
    grep 'charset=binary' | \
    grep 'x-executable\|x-archive\|x-sharedlib' | \
    awk -F: '{print $1}' | xargs strip -s

# Modifications to the environment that are necessary to run
RUN cd /opt/spack-environment && \
    spack env activate --sh -d . >> /etc/profile.d/z10_spack_environment.sh


# Bare OS image to run the installed executables
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

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

COPY --from=builder /opt/spack-environment /opt/spack-environment
COPY --from=builder /opt/software /opt/software
COPY --from=builder /opt/view /opt/view

ENV SPACK_TEST_SOLVER=clingo PATH=/opt/view/bin:$PATH

ENTRYPOINT ["/bin/bash", "--rcfile", "/etc/profile", "-l"]
