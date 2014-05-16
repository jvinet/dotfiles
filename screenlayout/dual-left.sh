#!/bin/sh
xrandr \
	--output DP2 --off \
	--output DP1 --off \
	--output VGA1 --off \
	--output HDMI2 --off \
	--output HDMI1 --mode 1920x1080 --pos 0x0 --rotate normal --primary \
	--output eDP1 --mode 1366x768 --right-of HDMI1 --rotate normal 

# re-scale wallpaper on new display
[ -f $HOME/.fehbg ] && . $HOME/.fehbg

