FROM phusion/baseimage:0.9.18
MAINTAINER Andrea Brancaleoni <miwaxe@gmail.com>

# Update System
RUN sed -i 's/main$/main universe multiverse restricted/' /etc/apt/sources.list
RUN apt-get -qq update

# Prepare Build Tools
RUN dpkg --add-architecture i386 && apt-get update -yq
RUN apt-get install -yq zlib1g-dev:i386 && apt-get install -yq openjdk-7-jdk \
	bison g++-multilib git gperf libxml2-utils make \
	python-networkx zip \
	bc schedtool unzip less
RUN apt-get install -y -q ccache
ADD ccache.sh /etc/profile.d/ccache.sh

# Create Builder user
RUN useradd -s /bin/bash --create-home builder
RUN echo 'builder:builder' | chpasswd
RUN adduser builder sudo

# Adding REPO
ADD https://storage.googleapis.com/git-repo-downloads/repo /usr/bin/repo
RUN chmod +rx /usr/bin/repo

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
