#!/bin/bash
#
# Using the ddccontrol facility, change the brightness on my two external
# monitors.

if [ "$1" = "" ]; then
	echo "usage: $0 <day|night|percent>"
	echo
	echo "The 'day' and 'night' arguments are presets. Alternately, you can"
	echo "specify an integer percentage to set an explicit value."
	exit 1
fi

case "$1" in
	day)   bri=100 ;;
	night) bri=30 ;;
	*)     bri=$1 ;;
esac

ddccontrol -r 0x10 -w $bri dev:/dev/i2c-9
ddccontrol -r 0x10 -w $bri dev:/dev/i2c-10
