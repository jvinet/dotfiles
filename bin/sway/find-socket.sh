#!/bin/bash

pid=`pgrep -x sway`
if [ -n "$pid" ]; then
	export SWAYSOCK=/run/user/`id -u`/sway-ipc.`id -u`.$pid.sock
	echo $SWAYSOCK
fi
