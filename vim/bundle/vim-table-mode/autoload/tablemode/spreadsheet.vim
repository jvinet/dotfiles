" ==============================  Header ======================================
" File:          autoload/tablemode/spreadsheet.vim
" Description:   Table mode for vim for creating neat tables.
" Author:        Dhruva Sagar <http://dhruvasagar.com/>
" License:       MIT (http://www.opensource.org/licenses/MIT)
" Website:       https://github.com/dhruvasagar/vim-table-mode
" Note:          This plugin was heavily inspired by the 'CucumberTables.vim'
"                (https://gist.github.com/tpope/287147) plugin by Tim Pope.
"
" Copyright Notice:
"                Permission is hereby granted to use and distribute this code,
"                with or without modifications, provided that this copyright
"                notice is copied with it. Like anything else that's free,
"                table-mode.vim is provided *as is* and comes with no warranty
"                of any kind, either expressed or implied. In no event will
"                the copyright holder be liable for any damamges resulting
"                from the use of this software.
" =============================================================================

" Private Functions {{{1
function! s:Sum(list) "{{{2
  let result = 0.0
  for item in a:list
    if type(item) == type(1) || type(item) == type(1.0)
      let result += item
    elseif type(item) == type('')
      let result += str2float(item)
    elseif type(item) == type([])
      let result += s:Sum(item)
    endif
  endfor
  return result
endfunction

function! s:Average(list) "{{{2
  return s:Sum(a:list)/len(a:list)
endfunction

" Public Functions {{{1
function! tablemode#spreadsheet#sid() "{{{2
  return maparg('<sid>', 'n')
endfunction
nnoremap <sid> <sid>

function! tablemode#spreadsheet#scope() "{{{2
  return s:
endfunction

function! tablemode#spreadsheet#GetFirstRow(line) "{{{2
  if tablemode#table#IsATableRow(a:line)
    let line = tablemode#utils#line(a:line)

    while tablemode#table#IsATableRow(line - 1) || tablemode#table#IsATableHeader(line - 1)
      let line -= 1
    endwhile
    if tablemode#table#IsATableHeader(line) | let line += 1 | endif

    return line
  endif
endfunction

function! tablemode#spreadsheet#MoveToFirstRow() "{{{2
  if tablemode#table#IsATableRow('.')
    call cursor(tablemode#spreadsheet#GetFirstRow('.'), col('.'))
  endif
endfunction

function! tablemode#spreadsheet#GetLastRow(line) "{{{2
  if tablemode#table#IsATableRow(a:line)
    let line = tablemode#utils#line(a:line)

    while tablemode#table#IsATableRow(line + 1) || tablemode#table#IsATableHeader(line + 1)
      let line += 1
    endwhile
    if tablemode#table#IsATableHeader(line) | let line -= 1 | endif

    return line
  endif
endfunction

function! tablemode#spreadsheet#MoveToLastRow() "{{{2
  if tablemode#table#IsATableRow('.')
    call cursor(tablemode#spreadsheet#GetLastRow('.'), col('.'))
  endif
endfunction

function! tablemode#spreadsheet#LineNr(row) "{{{2
  if tablemode#table#IsATableRow('.')
    let line = tablemode#spreadsheet#GetFirstRow('.')
    let row_nr = 0

    while tablemode#table#IsATableRow(line + 1) || tablemode#table#IsATableHeader(line + 1)
      if tablemode#table#IsATableRow(line)
        let row_nr += 1
        if row ==# row_nr | break | endif
      endif
      let line += 1
    endwhile

    return line
  endif
endfunction

function! tablemode#spreadsheet#RowNr(line) "{{{2
  let line = tablemode#utils#line(a:line)

  let rowNr = 0
  while tablemode#table#IsATableRow(line) || tablemode#table#IsATableHeader(line)
    if tablemode#table#IsATableRow(line) | let rowNr += 1 | endif
    let line -= 1
  endwhile

  return rowNr
endfunction

function! tablemode#spreadsheet#RowCount(line) "{{{2
  let line = tablemode#utils#line(a:line)

  let [tline, totalRowCount] = [line, 0]
  while tablemode#table#IsATableRow(tline) || tablemode#table#IsATableHeader(tline)
    if tablemode#table#IsATableRow(tline) | let totalRowCount += 1 | endif
    let tline -= 1
  endwhile

  let tline = line + 1
  while tablemode#table#IsATableRow(tline) || tablemode#table#IsATableHeader(tline)
    if tablemode#table#IsATableRow(tline) | let totalRowCount += 1 | endif
    let tline += 1
  endwhile

  return totalRowCount
endfunction

function! tablemode#spreadsheet#ColumnNr(pos) "{{{2
  let pos = []
  if type(a:pos) == type('')
    let pos = [line(a:pos), col(a:pos)]
  elseif type(a:pos) == type([])
    let pos = a:pos
  else
    return 0
  endif
  let row_start = stridx(getline(pos[0]), g:table_mode_separator)
  return tablemode#utils#strlen(substitute(getline(pos[0])[(row_start):pos[1]-2], '[^' . g:table_mode_separator . ']', '', 'g'))
endfunction

function! tablemode#spreadsheet#ColumnCount(line) "{{{2
  let line = tablemode#utils#line(a:line)

  return tablemode#utils#strlen(substitute(getline(line), '[^' . g:table_mode_separator . ']', '', 'g'))-1
endfunction

function! tablemode#spreadsheet#IsFirstCell() "{{{2
  return tablemode#spreadsheet#ColumnNr('.') ==# 1
endfunction

function! tablemode#spreadsheet#IsLastCell() "{{{2
  return tablemode#spreadsheet#ColumnNr('.') ==# tablemode#spreadsheet#ColumnCount('.')
endfunction

function! tablemode#spreadsheet#MoveToStartOfCell() "{{{2
  if getline('.')[col('.')-1] ==# g:table_mode_separator && !tablemode#spreadsheet#IsLastCell()
    normal! 2l
  else
    execute 'normal! F' . g:table_mode_separator . '2l'
  endif
endfunction

function! tablemode#spreadsheet#GetLastRow(line) "{{{2
  if tablemode#table#IsATableRow(a:line)
    let line = tablemode#utils#line(a:line)

    while tablemode#table#IsATableRow(line + 1) || tablemode#table#IsATableHeader(line + 1)
      let line += 1
    endwhile
    if tablemode#table#IsATableHeader(line) | let line -= 1 | endif

    return line
  endif
endfunction

function! tablemode#spreadsheet#GetFirstRow(line) "{{{2
  if tablemode#table#IsATableRow(a:line)
    let line = tablemode#utils#line(a:line)

    while tablemode#table#IsATableRow(line - 1) || tablemode#table#IsATableHeader(line - 1)
      let line -= 1
    endwhile
    if tablemode#table#IsATableHeader(line) | let line += 1 | endif

    return line
  endif
endfunction

function! tablemode#spreadsheet#DeleteColumn() "{{{2
  if tablemode#table#IsATableRow('.')
    for i in range(v:count1)
      call tablemode#spreadsheet#MoveToStartOfCell()
      call tablemode#spreadsheet#MoveToFirstRow()
      silent! execute "normal! h\<C-V>f" . g:table_mode_separator
      call tablemode#spreadsheet#MoveToLastRow()
      normal! d
    endfor

    call tablemode#table#TableRealign('.')
  endif
endfunction

function! tablemode#spreadsheet#DeleteRow() "{{{2
  if tablemode#table#IsATableRow('.')
    for i in range(v:count1)
      if tablemode#table#IsATableRow('.')
        normal! dd
      endif

      if !tablemode#table#IsATableRow('.')
        normal! k
      endif
    endfor

    call tablemode#table#TableRealign('.')
  endif
endfunction

function! tablemode#spreadsheet#Sum(range, ...) abort "{{{2
  let args = copy(a:000)
  call insert(args, a:range)
  return s:Sum(call('tablemode#spreadsheet#cell#GetCellRange', args))
endfunction

function! tablemode#spreadsheet#Average(range, ...) abort "{{{2
  let args = copy(a:000)
  call insert(args, a:range)
  return s:Average(call('tablemode#spreadsheet#cell#GetCellRange', args))
endfunction

