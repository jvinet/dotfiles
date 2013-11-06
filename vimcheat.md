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

Formatting
----------
  - Re-tab (or space) indentation: :ret (or :ret!)
  - Re-indent visual block: =
  - Remove one indent level from visual block: <
  - Add one indent level to visual block: >
  - Wrap text (based on tw) for paragraph: gqap

Opening/Finding files
---------------------
  - Ctrl-P open: \t
  - NERDTree toggle: \e
  - grep inside vim: :Grep <search> <files>
    - Close results: \w
  - grep -r for the word under the cursor: \g
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
  - Go back (tag stack): <C-t>

Use with other plugins:

  - :CtrlPTag
  - :TagbarToggle

Misc
----
  - Toggle Paste mode: \p
  - Turn off search highlighting: \q
  - Go back to previous location (jump list): <C-o>
  - Go forward to next location: <C-i>
