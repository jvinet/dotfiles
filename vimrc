set tabstop=2 shiftwidth=2 softtabstop=2

" Per-file options
autocmd BufNewFile,BufRead *.py setlocal sw=4 ts=4 sts=4 expandtab

"set mouse=
set mouse=a

set encoding=utf8

syntax on
color dusk

" Don't save backups
set nobackup

" Don't highlight searches
set nohlsearch

" Auto indent after a {
set autoindent
set smartindent

" Linewidth to endless
set textwidth=0

" Do not wrap lines automatically
set nowrap

" Don't show line numbers by default
set nonumber

" MonoDevelop / Mono
au BufNewFile,BufRead *.pp  set ft=cs

" Folding
au BufNewFile,BufRead * set foldmethod=manual
au BufNewFile,BufRead *.c,*.h,*.php,*.js,*.go  set foldmethod=indent
au BufNewFile,BufRead *.c,*.h,*.php,*.js,*.go  syn region myFold start="{" end="}" transparent fold
au BufNewFile,BufRead * set foldlevel=99
"set foldmethod=indent

" Don't bother folding small blocks
set foldminlines=5

" Autoclose folds, when moving out of them
"set foldclose=all

" Fold column
set foldcolumn=0

" Use incremental searching
set incsearch

" Jump 5 lines when running out of the screen
set scrolljump=5

" Indicate jump out of the screen when 3 lines before end of the screen
set scrolloff=3

" Correct indentation after opening a phpdocblock and automatic * on every
" line
set formatoptions=qroct

" Repair wired terminal/vim settings
set backspace=start,eol


" Config for buftabs plugin
let g:buftabs_only_basename=1
noremap <C-left> :bprev<CR>
noremap <C-right> :bnext<CR>


" {{{ Command mappings

" Map ; to run PHP parser check
au BufNewFile,BufRead *.php  noremap <C-B> :!php -l %<CR>

" Run love interpreter
au BufNewFile,BufRead *.lua  noremap <C-B> :!love-hg .<CR>

" }}}


" {{{ Automatic close char mapping

"inoremap { {<CR>}<C-O>O
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>

" }}} Automatic close char mapping

" {{{ Wrap visual selections with chars

:vnoremap ( "zdi(<C-R>z)<ESC>
:vnoremap { "zdi{<C-R>z}<ESC>
:vnoremap [ "zdi[<C-R>z]<ESC>
:vnoremap ' "zdi'<C-R>z'<ESC>
:vnoremap " "zdi"<C-R>z"<ESC>

" }}} Wrap visual selections with chars

