#!/bin/bash

PATH="/usr/bin:/usr/sbin"

set -o errexit	# set -e
set -o nounset	# set -u

shopt -s nullglob

renice --priority 19 --pid $$ > /dev/null
ionice --class 3     --pid $$ > /dev/null

umask 0022

DIR="/var/lib/libvirt/dnsmasq"

cd "$DIR"

for FILE in virbr*; do
	./dnsmasq-hosts.pl "$FILE"
done > hosts
pkill -f -HUP dnsmasq

