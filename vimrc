set tabstop=2
set sw=2

set mouse=

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

" Folding
au BufNewFile,BufRead *              set foldmethod=manual
au BufNewFile,BufRead *.c,*.h,*.php  set foldmethod=indent
au BufNewFile,BufRead *.c,*.h,*.php  syn region myFold start="{" end="}" transparent fold
au BufNewFile,BufRead *              set foldlevel=99
au BufNewFile,BufRead *.thtml        set ft=php
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
noremap <C-B> :!php -l %<CR>

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

" {{{ Dictionary completion

" The completion dictionary is provided by Rasmus:
" http://lerdorf.com/funclist.txt
set dictionary-=/home/jvinet/.vim/phpfunclist.txt dictionary+=/home/jvinet/.vim/phpfunclist.txt
" Use the dictionary completion
set complete-=k complete+=k

" }}} Dictionary completion

" {{{ Autocompletion using the TAB key

" This function determines, wether we are on the start of the line text (then tab indents) or
" if we want to try autocompletion
function InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

" Remap the tab key to select action with InsertTabWrapper
"inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" }}} Autocompletion using the TAB key

