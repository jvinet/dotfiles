" qfn.vim
" Create file notes in quickfix format
" Last Changed: 2008 April 20
" Author: Will Drewry <redpig@dataspill.org>
" License: See qfn.txt packaged with this file.
" Changes:
" = 2008-April-20
" + Removed forced F8 mapping. Whoops.

if v:version < 700
  echo "qfn.vim requires version 7.0 or higher"
  finish
endif

" Don't double load
if exists("s:loaded")
  finish
endif
let s:loaded = 1

" Add support for W or E
function s:QFNAddQ()
  let txt = input("Enter note: ")
  call s:QFNAdd(txt)
endfunction

function s:QFNAdd(note)
  if a:note == ''
    return
  endif
  let entry = {}
  " may need expand() here.
  let entry["filename"] = bufname("%")
  let entry["lnum"] = line('.')
  let entry["col"] = col('.')
  let entry["vcol"] = ''
  let entry["text"] = a:note
  let entry["type"] = 'E'
  call setqflist([entry], 'a')
endfunction

" Allow saving in a parseable quickfix format
function s:QFNSave(fname)
  let qflist = getqflist()
  let output = []
  for entry in qflist
    let line = bufname(entry.bufnr) . ":" . entry.lnum . ":" . entry.col . ":" . entry.text
    call add(output, line)
  endfor
  call writefile(output, a:fname)
endfunction

" Map these local functions globally with the script id
noremap <unique> <script> <Plug>QuickFixNote <SID>QFNAddQ
noremap <unique> <script> <Plug>QuickFixSave <SID>QFNSave
noremap <SID>QFNAddQ :call <SID>QFNAddQ()<CR>
noremap <SID>QFNSave :call <SID>QFNSave("quickfix.err")<CR>

" Drop them on the menu too
noremenu <script> Plugin.QFN\ Add  <SID>QFNAddQ
noremenu <script> Plugin.QFN\ Save <SID>QFNSave

" ex commands
if !exists(":QFNAdd")
  command -nargs=1 QFNAdd :call s:QFNAdd(<f-args>)
endif

if !exists(":QFNAddQ")
  command -nargs=0 QFNAddQ :call s:QFNAddQ()
endif

if !exists(":QFNSave")
  command -nargs=1 -complete=file QFNSave :call s:QFNSave(<f-args>)
endif

" global commands
"function QFN_Add(text)
"  s:QFNAdd(text)
"endfunction
"
"function QFN_Save(file)
"  s:QFNSave(file)
"endfunction

" basic maps
if !hasmapto('<Plug>QuickFixNote')
  map <unique> <Leader>m <Plug>QuickFixNote
endif

if !hasmapto('<Plug>QuickFixSave')
  map <unique> <Leader>s <Plug>QuickFixSave quickfix.err
endif

