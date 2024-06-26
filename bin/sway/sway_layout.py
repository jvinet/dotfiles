#!/usr/bin/env python3
"""
Resize containers in a Sway workspace to a predefined layout.
"""

import argparse
import os
import os.path
import sys
import time
import subprocess

from i3ipc import Connection

# Seconds to pause between commands.
WAIT = 0.1


def dump_container(c):
    print('-' * 80)
    for k, v in c.__dict__.items():
        print(k, '=', v)
    print('-' * 80)


def dbg(msg, *vals):
    print('D:', msg % vals)


def inspect_container(c, indent=0):
    def prn(s):
        print(' ' * indent, end='')
        print(s)

    # Interesting fields:
    #  - percent
    #  - floating (need to ignore these when resizing)
    #  - app_id (eg, "Alacritty", null for non-app containers)
    #  - focus (2- or 0-el list so far; coords?)
    #  - focused (bool)
    #  - name (seems to be same as window title)

    if c.nodes:
        prn(f"\033[1;94m• {c.id} is a container\033[0m")
        if c.focused: prn("--focused--")
        prn(f"  layout: {c.layout}")
        prn(f"  rect:   {c.rect.x}, {c.rect.y} w={c.rect.width} h={c.rect.height}")
        for child in c.nodes:
            inspect_container(child, indent + 4)
    else:
        prn(f"\033[1;96m• {c.id} is an app\033[0m")
        if c.focused: prn('  --focused--')
        # The `app_id` field does not appear to be populated for XWayland apps.
        app_id = c.app_id or c.window_instance
        title = c.name
        prn(f"  id:    {app_id}")
        prn(f"  title: {title}")
        prn(f"  rect:  {c.rect.x}, {c.rect.y} w={c.rect.width} h={c.rect.height}")


def move_leaves_to_workspace(i3, node, dst_ws_name):
    # Track all IDs we touch, so we can return to the caller.
    ids = []
    if node.nodes:
        for c in node.nodes:
            ids.extend(move_leaves_to_workspace(i3, c, dst_ws_name))
    else:
        dbg(f"Moving window {node.id} to workspace %s" % dst_ws_name)
        i3.command(f'[con_id={node.id}] focus')
        i3.command(f'move to workspace {dst_ws_name}')
        ids.append(node.id)
    time.sleep(WAIT)
    return ids


def flatten_tree(i3, ws):
    """
    Flatten a workspace tree so that all windows descend directly from the
    workspace node. There seems to be some logic in Sway that impedes this
    workflow, but there's a workaround that can be done by using a temporary
    workspace.

    See: https://github.com/swaywm/sway/issues/6818#issuecomment-1173037173
    """
    # Move everything to a temp workspace.
    ids = move_leaves_to_workspace(i3, ws, '_temp')
    # Now move everything back
    for id in ids:
        dbg(f"Moving window {id} to workspace %s" % ws.name)
        i3.command(f'[con_id={id}] focus')
        i3.command(f'move to workspace {ws.name}')
        time.sleep(WAIT)
    # Return focus to our original workspace
    i3.command(f'workspace {ws.name}')


def notify(msg):
    subprocess.run(['notify-send', '-t', '5000', 'Layouts', msg])


def menu(choices):
    choices = '\n'.join(choices)
    rv = subprocess.run(f'echo "{choices}" | rofi -dmenu -p Layout',
                        shell=True, capture_output=True)
    return rv.stdout.decode().strip()


def layout_equal(i3, ws):
    """
    All containers have equal width.
    """
    # Workspace dimensions
    ws_width = ws.rect.width

    # Get the top-level containers under `workspace`, in visual order from left
    # to right.
    containers = list(ws.nodes)
    containers = sorted(containers, key=lambda x: x.rect.x)

    # Every container has the same width.
    width = ws_width // len(containers)

    # Remember the focused window so we can return it.
    i3.command('mark --add current')

    for c in containers:
        dbg(f'{c.id}: setting to width {width}')
        i3.command(f'[con_id={c.id}] focus')
        i3.command(f'resize set width {width} px')
        time.sleep(WAIT)

    # Return focus and remove our mark.
    i3.command('[con_mark="current"] focus')
    i3.command('unmark current')


def layout_center(i3, ws):
    """
    Center container gets 50% of the width, while the containers to its left
    and right each get 25%.
    """
    if len(ws.nodes) != 3:
        notify("Center layout only works with 3 containers, you have %d" %
               len(ws.nodes))
        return 1

    # Workspace dimensions
    ws_width = ws.rect.width
    # We assume we have 3 windows to size. The middle one gets 50%, and the
    # others get 25%.
    widths = [ws_width * 0.25, ws_width * 0.5, ws_width * 0.25]
    widths = [int(x) for x in widths]

    # Get the top-level containers under `workspace`, in visual order from left
    # to right.
    containers = list(ws.nodes)
    containers = sorted(containers, key=lambda x: x.rect.x)

    # Remember the focused window so we can return it.
    i3.command('mark --add current')

    # Resize the middle container first, then the outer two.
    for idx in (1, 0, 2):
        c, w = containers[idx], widths[idx]
        dbg(f'{c.id}: setting to width {w}')
        i3.command(f'[con_id={c.id}] focus')
        i3.command(f'resize set width {w} px')
        time.sleep(WAIT)

    # Return focus and remove our mark.
    i3.command('[con_mark="current"] focus')
    i3.command('unmark current')


def main():
    parser = argparse.ArgumentParser(description='Change layout of windows in active workspace')
    parser.add_argument('action', nargs=1, choices=['tree', 'flatten', 'menu',
                                                    'equal', 'center'])

    # If a screen/tmux session persists across multiple Sway sessions, then we
    # can lose the path to the currently active socket. Look for a helper
    # script that can find it for us.
    dirname = os.path.dirname(sys.argv[0])
    socket_path = None
    if os.path.exists(f'{dirname}/find-socket.sh'):
        socket_path = os.popen(f'{dirname}/find-socket.sh').read().strip()
    if not socket_path:
        socket_path = os.environ.get('SWAYSOCK')
        if not socket_path:
            print("error: SWAYSOCK env var is not set")
            sys.exit(1)

    args = parser.parse_args()

    i3 = Connection(socket_path)
    tree = i3.get_tree()
    workspace = tree.find_focused().workspace()

    cmd = args.action[0]

    if cmd == 'tree':
        return inspect_container(workspace)

    if cmd == 'menu':
        choices = ['center', 'equal', 'flatten']
        rv = menu(choices)
        if rv:
            cmd = rv

    if cmd == 'flatten':
        return flatten_tree(i3, workspace)

    if cmd == 'equal':
        return layout_equal(i3, workspace)

    if cmd == 'center':
        return layout_center(i3, workspace)


if __name__ == '__main__':
    sys.exit(main())
