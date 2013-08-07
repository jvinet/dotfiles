Vim Cheat Sheet
===============

Leader: \

Moving
------
  - Move between buffers: <C-p> <C-n>
  -  PageUp/PageDn: [ ]
  - Move between windows: <C-h> <C-j> <C-k> <C-l>

Marks
-----
  - Mark designation can be a-z or A-Z (capitalized ones work across files)
  - To set a mark:  m + designation
  - To move to a mark: ' + designation

Tabs
----
  - new: \tn
  - only: \to
  - close: \tc
  - move: \tm
  - next: \]
  - prev: \[

Auto-Completion
---------------
  - ^N to complete the current word
  - ^P to complete, but search backwards

Opening/Finding files
---------------------
  - Ctrl-P open: \t
  - NERDTree toggle: \e
  - Grep inside vim: :Grep <search> <files>
    - Close results: \g
  - Change CWD to current file's dir: \cd

Tags
----
  - list:  :ts
  - next:  :tn
  - prev:  :tp
  - first: :tf
  - last:  :tl

Quick jumps:

  - When on a tag, go to defn: <C-]>
  - Go back: <C-t>

Use with other plugins:

  - :CtrlPTag
  - :TagbarToggle

Misc
----
  - Toggle Paste mode: \p
  - Turn off search highlighting: \q
