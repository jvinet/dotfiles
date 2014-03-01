#!/bin/bash
#
# Generate a tarball of:
#   - /etc (w/o shadow files)
#   - installed package list (pacman)
#   - installed package list (pip2/3)
#   - installed package lsit (npm)

if [ "`id -u`" != "0" ]; then
	echo "You should run this as root."
	exit 1
fi

cwd=`pwd`

mkdir /tmp/backup_sys
cd /tmp/backup_sys

tar c --exclude="shadow*" --exclude="gshadow*" /etc >etc.tar
pacman -Q >pacman.txt
pip2 list >pip2.txt
pip3 list >pip3.txt
npm ls -g >npm.txt

cd ..
tar cz backup_sys >$cwd/kilo_system.tar.gz

rm -rf backup_sys
