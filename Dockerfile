FROM centos:centos8

ARG PETALINUX_DESTDIR=/opt/pkg/petalinux
ARG PETALINUX_INSTALLER=petalinux-v2019.1-final-installer.run

ENV PETALINUX_DESTDIR=$PETALINUX_DESTDIR

RUN mkdir -p $PETALINUX_DESTDIR && \
	useradd -d $PETALINUX_DESTDIR petalinux && \
	chown -R petalinux:petalinux $PETALINUX_DESTDIR && \
	yum -y install gcc \
		autoconf \
		automake \
		bzip2 \
		chrpath \
		diffstat \
		file \
		gcc-c++ \
		glib2-devel \
		git \
		gpg \
		libtool \
		make \
		ncurses \
		ncurses-devel \
		net-tools \
		openssl-devel \
		patch \
		perl \
		redhat-lsb-core \
		rsync \
		socat \
		texinfo \
		unzip \
		wget \
		which \
		xterm \
		zlib-devel

COPY entrypoint.sh /entrypoint.sh
COPY $PETALINUX_INSTALLER /tmp
RUN chown petalinux:petalinux /tmp/$PETALINUX_INSTALLER && \
	chmod 755 /entrypoint.sh

USER petalinux

RUN VER=$(echo $PETALINUX_INSTALLER | sed 's/.*v\([0-9]\+\.[0-9]\+\).*/\1/') && \
	mkdir -p $PETALINUX_DESTDIR/$VER && \
	mkdir -p /tmp/petalinux-install-home && \
	cd /tmp/petalinux-install-home && \
	chmod 700 /tmp/$PETALINUX_INSTALLER && \
	yes | /tmp/$PETALINUX_INSTALLER $PETALINUX_DESTDIR/$VER && \
	rm -rf /tmp/$PETALINUX_INSTALLER

USER root

RUN yum -y install less && yum -y clean all

USER petalinux

ENTRYPOINT ["/entrypoint.sh"]
