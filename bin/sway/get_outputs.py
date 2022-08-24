#!/usr/bin/env python3
"""
Capture the current Sway output configuration. The output format will be
will be compatible with the format used by the kanshi utility.
"""
import json
import subprocess
from pprint import pprint


swaydata = subprocess.run('swaymsg -t get_outputs -r',
                          shell=True, capture_output=True)

outputs = json.loads(swaydata.stdout)
#pprint(outputs)

outputs = [o for o in outputs if o['active']]

print("profile {")

for o in outputs:
    identifier = f"{o['make']} {o['model']} {o['serial']}"
    mode = f"{o['current_mode']['width']}x{o['current_mode']['height']}"
    pos = f"{o['rect']['x']},{o['rect']['y']}"
    scale = o['scale']
    print(f'\toutput "{identifier}" enable mode {mode} position {pos} scale {scale}')

print("}")
