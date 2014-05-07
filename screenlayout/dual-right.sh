#!/bin/sh
xrandr --output DP2 --off --output DP1 --off --output HDMI2 --off --output HDMI1 --mode 1920x1080 --pos 1366x0 --rotate normal --output eDP1 --mode 1366x768 --pos 0x0 --rotate normal --output VGA1 --off

# re-scale wallpaper on new display
[ -f $HOME/.fehbg ] && . $HOME/.fehbg

