#!/usr/bin/env python2
"""
Use dbus to tell when the computer sleeps or wakes up, and log every
date/time when one such action occurs.

Requires python-daemon: pip2 install --user python-daemon
Requires python-dbus:   pip2 install --user python-dbus
"""

from subprocess import call
from datetime import datetime
import os, daemon
import dbus, gobject
from dbus.mainloop.glib import DBusGMainLoop

# Config
LOGFILE = '/home/jvinet/log/doorman.log'

def main():
    logf = open(LOGFILE, 'a', 0)  # unbuffered
    print >> logf, "%s - Doorman starting" % (datetime.now())

    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()

    def listener(goingIntoSleep):
        if goingIntoSleep:
            print >> logf, "%s - Going into sleep" % (datetime.now())
            # try to make sure the log entry is written to disk before we sleep.
            os.fsync()
        else:
            print >> logf, "%s - Waking up from sleep" % (datetime.now())

    bus.add_signal_receiver(listener,
                            dbus_interface="org.freedesktop.login1.Manager",
                            signal_name="PrepareForSleep")

    loop = gobject.MainLoop()
    loop.run()

if __name__ == '__main__':
    with daemon.DaemonContext():
        main()
