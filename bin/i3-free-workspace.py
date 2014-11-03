#!/usr/bin/env python2

import argparse

import i3

parser = argparse.ArgumentParser(description='switch to or move container to next or prev free workspace')
parser.add_argument('action', nargs=1, choices=['switch', 'move'])
parser.add_argument('direction', nargs=1, choices=['prev', 'next'])

args = parser.parse_args()


def focused(workspace):
    if workspace['focused']:
        return workspace

workspaces = i3.get_workspaces()
current_ws = filter(focused, workspaces)[0]['num']

ws_list = range(current_ws + 1, 11) + range(1, current_ws)

if args.direction[0] == 'prev':
    ws_list.reverse()

used_ws = [ws['num'] for ws in i3.get_workspaces()]

try:
    ws = next(ws for ws in ws_list if ws not in used_ws)
except StopIteration:
    sys.exit(3)

if args.action[0] == 'switch':
    i3.command('workspace', str(ws))
else:
    i3.command('move container to workspace', str(ws))
    # Switch to the new workspace.
    i3.command('workspace', str(ws))
