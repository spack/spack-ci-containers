# Dockerfile used to create a base image to test against CentOS 6 and Python 2.6
FROM centos:6

RUN yum install -y epel-release && \
    yum update -y && \
    yum --enablerepo epel groupinstall -y "Development Tools" && \
    yum install -y curl findutils gcc-c++ gcc gcc-gfortran hostname patchelf \
    make patch python-pip python-setuptools python-devel unzip wget xz subversion sudo && \
    yum install -y http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm && \
    yum install -y git && \
    yum clean all && \
    rm -rf /var/cache/yum

# Get realpath for CentOS 6 via a third party repository
RUN wget http://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el6/en/x86_64/rpmforge/RPMS/realpath-1.17-1.el6.rf.x86_64.rpm && \
    rpm -Uvh realpath-1.17-1.el6.rf.x86_64.rpm

# Install Python dependencies. We need to install mercurial from pip
# since the version coming with the OS is too old to make tests pass
RUN pip install pip six flake8==2.6.2 mercurial==3.9.2 urllib3==1.12 requests==2.12.2 setuptools==3.8.1 argparse

RUN useradd spack-test
USER spack-test
WORKDIR /home/spack-test
