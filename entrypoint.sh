#!/bin/sh

VER=2019.1

if [ "$1" = "test" ]; then
	shift

	source $PETALINUX_DESTDIR/$VER/settings.sh

	exec "$@"
fi

exec "$@"
