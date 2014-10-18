FROM ubuntu:12.04
MAINTAINER Andrea Brancaleoni <miwaxe@gmail.com>


ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/main$/main universe multiverse restricted/' /etc/apt/sources.list
RUN apt-get -qq update

# Prepare Build Tools
RUN apt-get install -y debconf bsdmainutils curl file dtach htop \
  apt-utils sudo software-properties-common python-software-properties
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get -qq update
RUN apt-get install -y -q oracle-java6-installer
RUN apt-get install --no-install-recommends -y -q git gnupg flex bison gperf build-essential \
  zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
  libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
  libgl1-mesa-dev g++-multilib mingw32 tofrodos \
  python-markdown libxml2-utils xsltproc zlib1g-dev:i386 \
  bc schedtool libbctsp-java libbcprov-java libbcpg-java
RUN ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
RUN apt-get install -y -q ccache
ADD ccache.sh /etc/profile.d/ccache.sh

# Create Builder user
RUN useradd -s /bin/bash --create-home builder
RUN echo 'builder:builder' | chpasswd
RUN adduser builder sudo

# Create SSH
RUN apt-get install -y -q openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Adding REPO
RUN curl https://storage.googleapis.com/git-repo-downloads/repo | sudo tee --append /usr/bin/repo
RUN chmod +x /usr/bin/repo

USER builder
WORKDIR /home/builder/android
# MOUNTPOINT /home/builder/android

USER root
RUN chown -R builder:users /home/builder/android
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
