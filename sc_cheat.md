SC Cheat Sheet
===============

SC is similar to Vim in that it is a modal editor.

Most of this stuff came from this article: http://www.linuxjournal.com/article/10699

Remember, when constructing commands in the top portion of the UI, Vi-like
editing rules apply. ie, you probably have to go into insert mode to
modify the command.


Moving Around
-------------
  - Move with Vim keys: hjkl
  - Go to cell B3: gB3
  - Mark cell as label 'a': ma
  - Copy cell marked as 'a': ca
  - Delete/yank/paste row:  dr, yr, pr
  - Delete/yank/paste col:  dc, yc, pc
  - Delete/yank/paste cell: dd, yd, pd
  - Force recalculation: @

Saving and Loading
------------------
  - Write text file: W<filename>
  - Write .sc file: P<filename>
  - Read .sc file: G<filename>
  - Export colon-delimited file:
    - S tblstyle=0
    - T output.csv
  - Export as LaTeX:
    - S tblstyle=latex
    - T output.tex

Colours
-------
  - Enable colour support: ^T C
  - Change value of colour 1: C1, "color 1 = @red;@black"
  - Assign colour 4 to a range of cells: rC , :, A0:D5 4

Data Entry
----------
  - Numbers: '=' then the number or formula
    - Eg: "F13-D14" or "@sum(A2:A15)"
  - Strings: A justification key, then the string
    - Justification: < \ >
  - Delete a value with 'x'
  - Edit an existing value: 'E' for strings, 'e' for numbers.
    - Once in edit mode, use Vim-style commands to change (eg: 'r' for
      replace), followed by Esc.

Formatting Cells
----------------
  - Justify the string in the current cell: { | }
  - Set a cell format with 'F', then a pattern (eg: "###.0000")
    - keep the quotes, they matter
  - Format a range/block of cells: F C4:D6 "###.0000"
  - Set default format for a column:
    - Option 1: f, then use h/l to adjust cell width and j/k to adjust
      precision.
    - Option 2: f, space, then 3 space-delimited numbers.
      - eg: "15 5 0"
        - first number: width of column (# of chars).
        - second number: # of digits to the right of the decimal point.
        - third number:
          - 0: fixed-point notation
          - 1: scientific notation
          - 2: engineering notation
          - 3: dates with a two-digit year
          - 4: dates with a four-digit year

Adding/Deleting Rows and Cols
-----------------------------
  - Insert column to the right: ic
  - Insert row above: ir
  - Delete current colunn: dc
  - Delete curent row: dr
  - Insert a new row below that is a copy of the current: ar
  - Insert a new col to the right that is a copy of the current: ac

Hiding Rows and Cols
-----------------------------
  - Hide column: Zc
  - Hide row: Zr
  - Show column: sr
  - Show row: sr
