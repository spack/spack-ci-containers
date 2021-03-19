FROM ghcr.io/alalazo/manylinux1_x86_64:manylinux1

RUN yum update  -y && \
    yum install -y unzip make patch gnupg2 git xz tar perl-devel gettext-devel && \
    rm -rf /var/cache/yum && \
    yum clean all

# Update ld.so.conf and ld.so.cache to find stuff in /usr/local/lib
RUN echo /usr/local/lib > /etc/ld.so.conf.d/libcrypt.conf && ldconfig

RUN adduser -m spack

# Switch to a non-root user
USER spack
ENV SPACK_CMD="/opt/python/cp39-cp39/bin/python /home/spack/spack/bin/spack"
WORKDIR /home/spack

# Use gettext and cmake as externals
COPY --chown=spack:spack packages.yaml /home/spack/.spack/packages.yaml

# Install CMake
RUN /opt/python/cp39-cp39/bin/pip install cmake

# Clone the repo and install Spack
RUN git clone https://www.github.com/spack/spack.git

# Install tar since the once that ships with CentOS 5 can't handle .xz archives
RUN ${SPACK_CMD} install tar 

# GCC 9.3.1 is installed on manylinux2014
RUN mkdir /home/spack/mirror

RUN ${SPACK_CMD} mirror create -d /home/spack/mirror -D gcc@9.3.0 && \
    ${SPACK_CMD} mirror add mirror file:///home/spack/mirror

RUN PATH=$(${SPACK_CMD} location -i tar)/bin:$PATH ${SPACK_CMD} install --only=dependencies gcc@9.3.0 && \
    ${SPACK_CMD} clean -a
RUN PATH=$(${SPACK_CMD} location -i tar)/bin:$PATH ${SPACK_CMD} install -v gcc@9.3.0 && ${SPACK_CMD} clean -a

# Register the compiler and move itout of the platform scope
RUN ${SPACK_CMD} compiler add $(${SPACK_CMD} location -i gcc) && \
    cp /home/spack/.spack/linux/compilers.yaml /home/spack/.spack/compilers.yaml

# Move to the correct branch
RUN cd spack && git fetch origin pull/22354/head:PR/22354 && git checkout PR/22354

# Run a script to build all the versions of clingo we could
COPY --chown=spack:spack bootstrap_clingo.sh /home/spack/bootstrap_clingo.sh
COPY --chown=spack:spack install_clingo.py /home/spack/install_clingo.py
COPY --chown=spack:spack create_binary_mirror.sh /home/spack/create_binary_mirror.sh
COPY --chown=spack:spack spack.patch /home/spack/spack/spack.patch

RUN cd spack && git apply spack.patch
RUN PATH=$(${SPACK_CMD} location -i tar)/bin:$PATH ${HOME}/bootstrap_clingo.sh
