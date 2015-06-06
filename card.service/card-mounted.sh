#!/bin/bash

BLOCK="/dev/mmcblk0"
LINK="$HOME/sd"

# slight delay between device appearing and mount happening
sleep 1

DIR=$(echo -en "$(grep "^$BLOCK" /proc/mounts | awk '{ print $2 }')")

if [ -n "$DIR" ]; then
	[ -h "$LINK" ] && rm -f "$LINK"
	ln -s "$DIR" "$LINK"
else
	rm -f "$LINK"
fi

