#!/bin/bash
# Source: https://bbs.archlinux.org/viewtopic.php?pid=1321200#p1321200

if [ "$1" = "" ]; then
	echo "usage: $0 <on|off>"
	exit 1
fi

if [ "$1" = "on" ]; then
	xrandr --setprovideroutputsource 1 0

	# The monitor name will now appear in xrandr.
	DISP=$(xrandr -q | grep 'DVI-' | awk '{print $1}')
	echo "Displaylink monitor is on $DISP"

	# To get the modeline: $(gtf 1366 768 59.9)

	# This command can fail if the modeline already exists.
	xrandr --newmode "1368x768_59.90"  85.72  1368 1440 1584 1800  768 769 772 795  -HSync +Vsync 2>/dev/null

	xrandr --addmode $DISP 1368x768_59.90

	exit 0
fi

if [ "$1" = "off" ]; then
	# If we don't do this, then some X apps will crash with a "BadRROutput" error
	# code when the USB cable is disconnected.
	xrandr --setprovideroutputsource 1 0x0

	exit 0
fi
