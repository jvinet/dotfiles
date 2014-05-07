#!/bin/sh

# If there's a DisplayLink monitor connected, its name will vary.
DISP=$(xrandr -q | grep 'DVI-' | awk '{print $1}')
[ -z "$DISP" ] && DISP="DVI-1-0"

xrandr \
	--output VIRTUAL1 --off \
	--output DP2 --off \
	--output DP1 --off \
	--output HDMI1 --off \
	--output HDMI2 --off \
	--output VGA1 --off \
	--output $DISP --mode 1368x768_59.90 --pos 0x0 --rotate normal \
	--output eDP1 --mode 1366x768 --right-of $DISP --rotate normal

# re-scale wallpaper on new display
[ -f $HOME/.fehbg ] && . $HOME/.fehbg

