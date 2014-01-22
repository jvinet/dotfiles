set tabstop=2 shiftwidth=2 softtabstop=2
set nocompatible

" Per-file options
autocmd BufNewFile,BufRead *.py   setlocal sw=4 ts=4 sts=4 et
autocmd BufNewFile,BufRead *.md   setlocal et tw=74
autocmd BufNewFile,BufRead *.wiki setlocal noet tw=74
autocmd BufNewFile,BufRead *.rst  setlocal sw=4 ts=4 sts=4 tw=74 et

" {{{ Command mappings
autocmd BufNewFile,BufRead *.php map <leader>; :!php -l %<CR>
autocmd BufNewFile,BufRead *.js map <leader>; :!jshint %<CR>
" }}}

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

" Enable smart keyword matching ('%' key) and smart(er) file types
filetype plugin on
runtime macros/matchit.vim

" Redraw
noremap <leader>r :redraw!<CR>
" Toggle visible tab characters
noremap <leader>l :set list!<CR>
" Toggle line numbers
noremap <leader>n :set number!<CR>

" Switch CWD to the directory of the open buffer
" This (and more) inspired from http://amix.dk/vim/vimrc.html
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" When using tab completion for filenames, only complete as far
" as the match goes
set wildmode=longest:full
set wildmenu

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Show matching brackets when cursor is over them
set showmatch

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
nmap <leader>q :nohlsearch<CR>

" When in visual mode, pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>
function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Toggle paste mode
map <leader>p :setlocal paste!<CR>

" Show vimgrep matches in the quickfix window
command! -nargs=+ Grep execute 'silent grep! -r <args>' | copen 33
" Search for the word under the cursor and display results in the quickfix
map <leader>g :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>
" Close the quickfix window
map <leader>w :cclose<CR>

" Quick AES encryption/decryption
command! Enc execute '%!openssl aes-256-cbc -salt'
command! Dec execute '%!openssl aes-256-cbc -d -salt'

" Jump 5 lines when running out of the screen
set scrolljump=5

" Indicate jump out of the screen when 3 lines before end of the screen
set scrolloff=3

" Correct indentation after opening a phpdocblock and automatic * on every
" line
set formatoptions=qroct

" Repair wired terminal/vim settings
set backspace=start,eol

" Lower the time that Vim waits to look for matching keymaps (ms)
set timeoutlen=400

" Easy movement between buffers
let g:buftabs_only_basename=1
noremap <C-p> :bprev<CR>
noremap <C-n> :bnext<CR>

" Redraw the screen
map <leader>r :redraw!<CR>

" Treat long lines as break lines
map j gj
map k gk

" PageUp/PageDown without requiring a Fn+Up/Dn combo
"noremap [ [5~
"noremap ] [6~

" Easy movement between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Easy tab control
map <leader>tn :tabnew<CR>
map <leader>to :tabonly<CR>
map <leader>tc :tabclose<CR>
map <leader>tm :tabmove<CR>
map <leader>]  :tabnext<CR>
map <leader>[  :tabprev<CR>

" Don't remove indentation when adding '#' comments
inoremap # X#

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
nmap <leader>e :NERDTreeToggle<CR>
" }}}

" {{{ TagBar
nmap <leader>b :TagbarToggle<CR>
" }}}

" {{{ Ctrl-P Plugin
"set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<leader>t'
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0
" }}}

" {{{ VimWiki
let g:vimwiki_list = [{'path': '~/work/personal/vimwiki/', 'path_html': '~/work/personal/vimwiki/html'},
                   \  {'path': '~/work/betsmart/vimwiki/', 'path_html': '~/work/betsmart/vimwiki/html'}]
" }}}

" {{{ Cursorline
hi CursorLine ctermbg=017 cterm=none
augroup CursorLine
	au!
	au InsertEnter * setlocal cursorline
	au InsertLeave * setlocal nocursorline
augroup END
" }}}

" {{{ Tabs
hi TabLineFill ctermfg=255 ctermbg=255 cterm=underline
hi TabLine ctermfg=000 ctermbg=255
hi TabLineSel ctermfg=000 ctermbg=247 cterm=underline
hi TabTitle ctermfg=018 cterm=bold
" }}}
	

" {{{ Statusline
set laststatus=2

set statusline=
set statusline+=%-99f    " Filename, set to aggressive fill

set statusline+=%=    " everything after this is right-aligned
set statusline+=%3*%{&modified?'[+]\ ':''} " modified flag
set statusline+=%4*%{&readonly?'[RO]\ ':''} " read-only flag 
set statusline+=%5*%{&paste?'[P]\ ':''} " paste mode

set statusline+=%< " Truncate here if we run out of space
set statusline+=%2*\|\ %1*\%{&ff}\ %2*\| " File format
set statusline+=%1*\ %{strlen(&fenc)?&fenc:'none'}\ %2*\| " file encoding
set statusline+=%1*\ %{tolower(&ft)}\ %2*\| " Filetype, lowercase without surrounding square brackets
set statusline+=%1*\ %l,%c\ %2*\| " line, col position
set statusline+=%1*\ %p%% " Total lines, % of file

" TODO: add guibg/fg color triplets
"       http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim

function! InsertStatuslineColor(mode)
	if a:mode == 'i'
		hi statusline guifg=#5f87d7 ctermfg=068 ctermbg=255
		hi statuslineNC ctermbg=248 ctermfg=237
	elseif a:mode == 'r'
		hi statusline guifg=#870000 ctermfg=088 ctermbg=255
		hi statuslineNC ctermbg=248 ctermfg=237
	endif
endfunction

function! ResetStatuslineColor()
	hi statusline ctermbg=252 ctermfg=022
	hi statuslineNC ctermbg=248 ctermfg=237
	hi User1 ctermfg=245 ctermbg=237
	hi User2 ctermfg=240 ctermbg=237
	hi User3 ctermfg=184 ctermbg=237
	hi User4 ctermfg=173 ctermbg=237
	hi User5 ctermfg=195 ctermbg=237
endfunction

call ResetStatuslineColor()

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * call ResetStatuslineColor()
" }}}
