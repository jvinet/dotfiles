#!/bin/bash

# External output names can vary, so figure out which is which.
d_hp=$(swaymsg -t get_outputs | jq '.[] | select(.make == "Hewlett Packard") | .name')
d_dell=$(swaymsg -t get_outputs | jq '.[] | select(.make == "Dell Inc.") | .name')

# Disable the HP monitor.
swaymsg output $d_hp disable

# Setup the Dell monitor.
#   (Laptop screen is scale=2.0, so we divide by 2 when positioning DP-4)
swaymsg output $d_dell enable pos 1920 0 res 2560 1600 scale 1.0

