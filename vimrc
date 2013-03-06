set tabstop=2 shiftwidth=2 softtabstop=2
set nocompatible

" Per-file options
autocmd BufNewFile,BufRead *.py setlocal sw=4 ts=4 sts=4 expandtab

"set mouse=
set mouse=a

set encoding=utf8

syntax on
color dusk

" Make sure we're getting 256 colors when it's available
if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
	set t_Co=256
endif

" Don't save backups
set nobackup

" Auto indent after a {
set autoindent
set smartindent

" Linewidth to endless
set textwidth=0

" Do not wrap lines automatically
set nowrap

" Don't show line numbers by default
set nonumber

" ServiceStack
au BufNewFile,BufRead *.pp  set ft=cs

" Folding
"au BufNewFile,BufRead *              set foldmethod=manual
"au BufNewFile,BufRead *.c,*.h,*.php  set foldmethod=indent
"au BufNewFile,BufRead *.c,*.h,*.php  syn region myFold start="{" end="}" transparent fold
"au BufNewFile,BufRead *              set foldlevel=99

set foldmethod=indent
" Don't fold anything by default - I'll close the folds myself
set foldlevel=99

" Don't bother folding small blocks
set foldminlines=5

" Autoclose folds, when moving out of them
"set foldclose=all

" Fold column
set foldcolumn=0

" Searching
set incsearch
set ignorecase
set smartcase
set hlsearch
" <Leader> is the \ key
nmap <Leader>q :nohlsearch<CR>

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
noremap <C-p> :bprev<CR>
noremap <C-n> :bnext<CR>


" {{{ Command mappings
" Map ; to run PHP parser check
noremap <C-b> :!php -l %<CR>
" }}}


" {{{ Automatic close char mapping
"inoremap { {<CR>}<C-O>O
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
" }}}

" {{{ Wrap visual selections with chars
vnoremap ( "zdi(<C-R>z)<ESC>
vnoremap { "zdi{<C-R>z}<ESC>
vnoremap [ "zdi[<C-R>z]<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>
vnoremap " "zdi"<C-R>z"<ESC>
" }}}

" Activate pathogen
execute pathogen#infect()

" {{{ NERDTree
nmap <Leader>e :NERDTreeToggle<CR>
" }}}

" {{{ Ctrl-P Plugin
"set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<Leader>t'
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0
" }}}

" {{{ Cursorline
hi CursorLine ctermbg=017 cterm=none
augroup CursorLine
	au!
	au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
	au WinLeave * setlocal nocursorline
augroup END
" }}}

" {{{ Statusline
set laststatus=2

set statusline=%<
set statusline+=%-999F    " Filename, set to fill the left side
set statusline+=%3*%m " modified flag
set statusline+=%4*%r " read-only flag
set statusline+=%=    " everything after this is right-aligned
set statusline+=%1*\%{&ff}\ %2*\| " File format
set statusline+=%1*\ %{strlen(&fenc)?&fenc:'none'}\ %2*\| " file encoding
set statusline+=%1*\ %{tolower(&ft)}\ %2*\| " Filetype, lowercase without surrounding square brackets
set statusline+=%1*\ %l,%c\ %2*\| " line, col position
set statusline+=%1*\ %p%% " Total lines, % of file

" TODO: add guibg/fg color triplets
"       http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim

function! InsertStatuslineColor(mode)
	if a:mode == 'i'
		hi statusline guifg=#5f87d7 ctermfg=068 ctermbg=255
		hi statuslineNC ctermbg=030
	elseif a:mode == 'r'
		hi statusline guifg=#870000 ctermfg=088 ctermbg=255
		hi statuslineNC ctermbg=030
	endif
endfunction

function! ResetStatuslineColor()
	hi statusline ctermbg=252 ctermfg=022
	hi statuslineNC ctermbg=248 ctermfg=237
	hi User1 ctermfg=245 ctermbg=237
	hi User2 ctermfg=240 ctermbg=237
	hi User3 ctermfg=051 ctermbg=237
	hi User4 ctermfg=202 ctermbg=237
endfunction

call ResetStatuslineColor()

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * call ResetStatuslineColor()
" }}}
