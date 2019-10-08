#!/bin/sh

VER=${VER-2018.3}
PROJECT_DIR=${PROJECT_DIR-/project}
BUILD_DIR=${BUILD_DIR-/build}

export PETALINUX=${PETALINUX-/opt/pkg/petalinux/$VER}

export LANG=${LANG-en_US.UTF-8}

if [ "$1" = "build" ]; then
	shift

	source $PETALINUX/settings.sh
	TEMPDIR=$(mktemp -d)
	rsync -avz --progress "${PROJECT_DIR}/" "${TEMPDIR}/"

	cd $TEMPDIR
	petalinux-build -x mrproper
	rm -rf components/plnx_workspace
	petalinux-config

	exec petalinux-build "$@"
fi

exec "$@"
