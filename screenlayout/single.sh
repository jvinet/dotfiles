#!/bin/sh

# If there's a DisplayLink monitor connected, its name will vary.
DISP=$(xrandr -q | grep 'DVI-' | awk '{print $1}')
[ -z "$DISP" ] && DISP="DVI-1-0"

xrandr \
	--output DP2 --off \
	--output DP1 --off \
	--output HDMI2 --off \
	--output HDMI1 --off \
	--output eDP1 --mode 1366x768 --pos 0x0 --rotate normal --primary \
	--output $DISP --off \
	--output VGA1 --off

# re-scale wallpaper on new display
[ -f $HOME/.fehbg ] && . $HOME/.fehbg
