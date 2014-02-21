#!/usr/bin/env python2
"""
Listens for DBus signals when the computer goes on/off battery power,
and adjusts CPU speed to save juice when necessary.
"""

from subprocess import call
import dbus, gobject
from dbus.mainloop.glib import DBusGMainLoop

dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
bus = dbus.SessionBus()

def listener(onBattery):
    if onBattery:
        call(['/usr/bin/cpuspeed', 'powersave'])
    else:
        call(['/usr/bin/cpuspeed', 'performance'])

bus.add_signal_receiver(listener,
                        dbus_interface="org.freedesktop.PowerManagement",
                        signal_name="OnBatteryChanged")

loop = gobject.MainLoop()
loop.run()
