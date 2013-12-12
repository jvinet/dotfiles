#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# set key repeat rate
xset r rate 300
# load keyboard modifications
xmodmap ~/.Xmodmap

# start pulseaudio if it isn't running already
if [ ! "`pgrep pulseaudio`" ]; then
	pulseaudio --start
fi

#exec startxfce4
exec i3
