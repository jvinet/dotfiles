set tabstop=2 shiftwidth=2 softtabstop=2
set nocompatible

" Activate pathogen
execute pathogen#infect()

" Use the mouse
set mouse=a

set encoding=utf8

" Color theme
syntax on
color dusk

" Make sure we're getting 256 colors when it's available
"if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
"	set t_Co=256
"endif

" Don't save backups
set nobackup

" Per-file options
autocmd BufNewFile,BufRead *.sh   setlocal sw=2 ts=2 sts=2 noet
autocmd BufNewFile,BufRead *.py   setlocal sw=4 ts=4 sts=4 et
autocmd BufNewFile,BufRead *.clj  setlocal sw=3 ts=3 sts=3 et
autocmd BufNewFile,BufRead *.md   setlocal et tw=78 list ft=markdown
autocmd BufNewFile,BufRead *.adoc setlocal et tw=78 list ft=asciidoc
autocmd BufNewFile,BufRead *.wiki setlocal noet tw=74
autocmd BufNewFile,BufRead *.rst  setlocal sw=3 ts=3 sts=3 tw=74 et
autocmd BufNewFile,BufRead *.json setlocal ft=json
autocmd BufNewFile,BufRead *.yaml setlocal sw=2 ts=2 sts=2 et
autocmd BufNewFile,BufRead *.html setlocal sw=4 ts=4 sts=4 et

" Cheap/simple spreadsheets in Vim
autocmd BufNewFile,BufRead *.tsv  setlocal ts=16 sts=16 noet number list
" Columnar movements
autocmd BufNewFile,BufRead *.tsv  map L f	W
autocmd BufNewFile,BufRead *.tsv  map H F	B

" Show tabs and line numbers when coding
autocmd BufNewFile,BufRead *.sh     setlocal number
autocmd BufNewFile,BufRead *.zig    setlocal number
autocmd BufNewFile,BufRead *.ex     setlocal number
autocmd BufNewFile,BufRead *.exs    setlocal number
autocmd BufNewFile,BufRead *.py     setlocal number
autocmd BufNewFile,BufRead *.php    setlocal number
autocmd BufNewFile,BufRead *.js     setlocal number
autocmd BufNewFile,BufRead *.ts     setlocal number
autocmd BufNewFile,BufRead *.json   setlocal number
autocmd BufNewFile,BufRead *.clj    setlocal number
autocmd BufNewFile,BufRead *.java   setlocal number
autocmd BufNewFile,BufRead *.go     setlocal number
autocmd BufNewFile,BufRead *.c      setlocal number
autocmd BufNewFile,BufRead *.h      setlocal number
autocmd BufNewFile,BufRead *.m      setlocal number
autocmd BufNewFile,BufRead *.nim    setlocal number
autocmd BufNewFile,BufRead *.cpp    setlocal number
autocmd BufNewFile,BufRead *.lua    setlocal number
autocmd BufNewFile,BufRead *.html   setlocal number
autocmd BufNewFile,BufRead *.coffee setlocal number
autocmd BufNewFile,BufRead *.rkt    setlocal number

" Folders
autocmd FileType markdown set foldexpr=NestedMarkdownFolds()

" Linters
autocmd BufNewFile,BufRead *.php map <leader>; :!php -l %<CR>
autocmd BufNewFile,BufRead *.js  map <leader>; :!jshint %<CR>
autocmd BufNewFile,BufRead *.py  map <leader>; :!pylint -r n -f colorized %<CR>

" Enable smart keyword matching ('%' key) and smart(er) file types
filetype plugin on
filetype indent on
runtime macros/matchit.vim

" Redraw
noremap <leader>r :redraw!<CR>
" Toggle visible tab characters
noremap <leader>l :set list!<CR>
" Toggle line numbers
noremap <leader>n :set number!<CR>
" Toggle visual marks (vim-signature plugin)
noremap <leader>m :SignatureToggle<CR>
" Investigate (investigate.vim plugin)
noremap <leader>i :call investigate#Investigate()<CR>
" Use Zeal for Investigate.
" let g:investigate_command_for_python = '/usr/bin/zeal --query ^s'
noremap <leader>z :!zeal --query "<cword>"&<CR><CR>

" List characters use a less-noisy pipe to show tabs, instead of ^I
" Don't bother showing EOL characters either.
set listchars=tab:\|.,trail:.,extends:>,precedes:<,eol:\ 

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
set foldmethod=indent

" Don't fold anything by default - I'll close the folds myself
set foldlevel=99

" Don't bother folding small blocks
set foldminlines=5

" Autoclose folds when moving out of them
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
" Search for the word under the cursor within the current file and display
" results in the quickfix.
map <leader>g :execute "vimgrep /" . expand("<cword>") . "/j %" <Bar> cw<CR>
" Same as above, but do it recursively for all files under the CWD.
map <leader>gr :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>
" Same as above, but use Ack.
map <leader>ga :execute "Ack " . expand("<cword>")<CR>

" Switch to hexadecimal view.
map <leader>h :call ToggleHex()<CR>
function! ToggleHex()
	if exists('w:hex')
		unlet w:hex
		exec ':%!xxd -r'
	else
		exec ':%!xxd'
		let w:hex=1
	endif
endfunction

" Close the quickfix window
map <leader>cw :cclose<CR>
" Open the quickfix window
map <leader>co :copen<CR>
" Clear the quickfix window
map <leader>cc :call setqflist([])<CR>

" Close the location-list window
map <leader>lw :lclose<CR>
" Open the location-list window
map <leader>lo :lopen<CR>

" Quick AES encryption/decryption
command! Enc execute '%!openssl enc -aes-256-cbc -pbkdf2 -a -salt'
command! Dec execute '%!openssl enc -aes-256-cbc -pbkdf2 -a -d -salt'

" Auto encrypt/decrypt .aes files with AESCrypt
"   (It's more portable than openssl on Android)
function! s:AESReadPre()
    set cmdheight=3
    set viminfo=
    set noswapfile
    set shell=/bin/sh
    set bin
endfunction
function! s:AESReadPost()
    let l:expr = "0,$!aescrypt -d -"

    silent! execute l:expr
    if v:shell_error
        silent! 0,$y
        silent! undo
        echo "COULD NOT DECRYPT USING EXPRESSION: " . expr
        echo "ERROR FROM AESCRYPT:"
        echo @"
        echo "COULD NOT DECRYPT"
        return
    endif
    set nobin
    set cmdheight&
    set shell&
    execute ":doautocmd BufReadPost ".expand("%:r")
    redraw!
endfunction
function! s:AESWritePre()
    set cmdheight=3
    set shell=/bin/sh
    set bin
		let l:expr = "0,$!aescrypt -e -"

    silent! execute l:expr
    if v:shell_error
        silent! 0,$y
        silent! undo
        echo "COULD NOT ENCRYPT USING EXPRESSION: " . expr
        echo "ERROR FROM AESCRYPT:"
        echo @"
        echo "COULD NOT ENCRYPT"
        return
    endif
endfunction
function! s:AESWritePost()
    silent! undo
    set nobin
    set shell&
    set cmdheight&
    redraw!
endfunction
autocmd BufReadPre,FileReadPre     *.aescrypt call s:AESReadPre()
autocmd BufReadPost,FileReadPost   *.aescrypt call s:AESReadPost()
autocmd BufWritePre,FileWritePre   *.aescrypt call s:AESWritePre()
autocmd BufWritePost,FileWritePost *.aescrypt call s:AESWritePost()

" Switch 0 and ^ (we can use _ instead of ^ to avoid a recursive mapping)
map 0 _
map ^ 999h
map <leader>0 ^

" Jump 5 lines when running out of the screen
set scrolljump=5

" Indicate jump out of the screen when 3 lines before end of the screen
set scrolloff=3

" See ':help fo-table' for an explanation of each option char.
set formatoptions=qctnj1

" Repair wired terminal/vim settings
set backspace=start,eol

" Lower the time that Vim waits to look for matching keymaps (ms)
set timeoutlen=400

" Easy movement between buffers
let g:buftabs_only_basename=1
noremap <C-p> :bprev<CR>
noremap <C-n> :bnext<CR>

" Treat long lines as break lines
map j gj
map k gk

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

" If I'm in Termux or some other hamstrung environment, I may not be able to
" remap Capslock to Esc. This is an acceptable workaround.
inoremap kj <esc>

" Wrap visual selections with chars
vnoremap ( "zdi(<C-R>z)<ESC>
vnoremap { "zdi{<C-R>z}<ESC>
vnoremap [ "zdi[<C-R>z]<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>
vnoremap " "zdi"<C-R>z"<ESC>

" Easy Motion: Search for character
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_use_upper = 1
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-s)
nmap S <Plug>(easymotion-s2)

" UndoTree
nmap <leader>u :UndotreeToggle<CR>

" NERDTree (often requires a redraw)
nmap <leader>e :NERDTreeToggle<CR>:sleep 100m<CR>:redraw!<CR>
nmap <leader>f :NERDTreeFocus<CR>

" TagBar
nmap <leader>b :TagbarToggle<CR>

" QFN (mnemonic: 'a' for annotate)
map <leader>an :QFNAddQ<CR>
map <leader>as :QFNSave annotations.txt<CR>

" I don't even know how to use Ex mode.
nnoremap Q <nop>

" Toggle on diff mode for the current buffer.
nmap <leader>d :call DiffToggle()<CR>
function! DiffToggle()
	if &diff
		diffoff
	else
		diffthis
	end
endfunction

" Ctrl-P Plugin
let g:ctrlp_map = '<leader>o'
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0
" Search by tag - massively useful
map <leader>. :CtrlPTag<CR>

" Change the bg color of all the editor space at 80 and >120 cols
let &colorcolumn="80,".join(range(120,999), ",")

" Highlight trailing whitespace   
if hlexists("TrailingWhitespace")
	match TrailingWhitespace /\s\+$/
endif

" Visually indicate when I'm over 80-cols on line length, and add the ability
" to turn it on/off. Show text with a dark-red background, but show regular
" syntax highlighting.
if hlexists("OverLength")
	map <leader>k :call ToggleOverLength()<CR>
	function! ToggleOverLength()
		if exists('w:m1')
			call matchdelete(w:m1)
			unlet w:m1
		else
			let w:m1=matchadd('OverLength', '\%81v.\+', 11)
		endif
	endfunction
	"call ToggleOverLength()
else"
	map <leader>k :echo "No 'OverLength' highlight group in color settings."<CR>
endif

" Reset any residual colour styling that may persist after Vim exits.
"   NB: If in tmux, you'll probably want this option: set-window-option -g alternate-screen off
"au VimLeave * :!/bin/sh -c "echo -ne \"\033[0m\""

" Clear screen at exit
au VimLeave * :!clear

" Statusline
set laststatus=2

let &stl=""
if exists('*StatuslineColor')
	let &stl.="%{StatuslineColor()}"
else
	hi StatusLine ctermfg=237 ctermbg=250
	hi User1 ctermfg=015 ctermbg=237
	hi User2 ctermfg=232 ctermbg=237
	hi User3 ctermfg=184 ctermbg=237
	hi User4 ctermfg=184 ctermbg=237
	hi User5 ctermfg=184 ctermbg=237
endif
let &stl.="%1*%f"                       " filename

let &stl.="%="                          " everything after this is right-aligned
let &stl.="%3*%{&modified?'[+]\ ':''}"  " modified flag
let &stl.="%4*%{&readonly?'[R]\ ':''}"  " read-only flag
let &stl.="%5*%{&paste?'[P]\ ':''}"     " paste mode

let &stl.="%<"                          " truncate here if we run out of space
let &stl.="%2*\|\ %1*\%{&ff}\ %2*\|"    " file format
let &stl.="%1*\ %{strlen(&fenc)?&fenc:'none'}\ %2*\|" " file encoding
let &stl.="%1*\ %{tolower(&ft)}\ %2*\|" " filetype, lowercase without surrounding square brackets
let &stl.="%1*\ %l,%c\ %2*\|"           " line, col position
let &stl.="%1*\ %p%%"                   " total lines, % of file
