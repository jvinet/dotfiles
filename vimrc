set tabstop=2 shiftwidth=2 softtabstop=2
set nocompatible

" Per-file options
autocmd BufNewFile,BufRead *.py   setlocal sw=4 ts=4 sts=4 et
autocmd BufNewFile,BufRead *.md   setlocal et tw=74
autocmd BufNewFile,BufRead *.wiki setlocal noet tw=74
autocmd BufNewFile,BufRead *.rst  setlocal sw=4 ts=4 sts=4 tw=74 et

" Show tabs when coding
autocmd BufNewFile,BufRead *.py     setlocal list
autocmd BufNewFile,BufRead *.php    setlocal list
autocmd BufNewFile,BufRead *.js     setlocal list
autocmd BufNewFile,BufRead *.c      setlocal list
autocmd BufNewFile,BufRead *.cpp    setlocal list
autocmd BufNewFile,BufRead *.lua    setlocal list
autocmd BufNewFile,BufRead *.html   setlocal list
autocmd BufNewFile,BufRead *.coffee setlocal list

" Linters
autocmd BufNewFile,BufRead *.php map <leader>; :!php -l %<CR>
autocmd BufNewFile,BufRead *.js  map <leader>; :!jshint %<CR>
autocmd BufNewFile,BufRead *.py  map <leader>; :!pylint -r n -f colorized %<CR>

" Use the mouse
set mouse=a

set encoding=utf8

" Color theme
syntax on

" Figure out what sort of color scheme we should be using. The default is
" 'dusk', my bright-on-dark scheme. If the VIMCOLOR environment variable is
" set, then use that, giving preference to "solarized" for the generic
" settings of "light" or "dark".
if $VIMCOLOR == 'light'
	set background=light
	let g:solarized_termcolors=256
	color solarized
elseif $VIMCOLOR == 'dark'
	set background=dark
	let g:solarized_termcolors=256
	color solarized
elseif $VIMCOLOR == 'molokai'
	let g:molokai_original=1
	let g:rehash256=1
	color molokai
elseif $VIMCOLOR != ''
	color $VIMCOLOR
else
	color dusk
endif

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

" List characters use a less-noisy pipe to show tabs, instead of ^I
" Don't both showing EOL character either.
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
"au BufNewFile,BufRead *              set foldmethod=manual
"au BufNewFile,BufRead *.c,*.h,*.php  set foldmethod=indent
"au BufNewFile,BufRead *.c,*.h,*.php  syn region myFold start="{" end="}" transparent fold
"au BufNewFile,BufRead *              set foldlevel=99

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

" When in visual-block mode, hit 's' to replace selected tabs with 2 spaces.
" Relies on the vis plugin.
vnoremap s :B s/	/  /g<CR>

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

" Close the quickfix window
map <leader>cw :cclose<CR>
" Open the quickfix window
map <leader>co :copen<CR>
" Clear the quickfix window
map <leader>cc :call setqflist([])<CR>

" Quick AES encryption/decryption
command! Enc execute '%!openssl aes-256-cbc -salt'
command! Dec execute '%!openssl aes-256-cbc -d -salt'

" I often hit :W when I actually mean :w
command! W write

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

" Automatic close char mapping
"inoremap { {<CR>}<C-O>O
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>

" Wrap visual selections with chars
vnoremap ( "zdi(<C-R>z)<ESC>
vnoremap { "zdi{<C-R>z}<ESC>
vnoremap [ "zdi[<C-R>z]<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>
vnoremap " "zdi"<C-R>z"<ESC>

" Activate pathogen
execute pathogen#infect()

" Easy Motion: Search for character
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_use_upper = 1
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-s)
nmap S <Plug>(easymotion-s2)

" Gundo: Toggle undo history pane.
nmap <leader>u :GundoToggle<CR>

" NERDTree (often requires a redraw)
nmap <leader>e :NERDTreeToggle<CR>:sleep 100m<CR>:redraw!<CR>

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

" VimWiki
let g:vimwiki_list = [{'path': '~/work/personal/vimwiki/', 'path_html': '~/work/personal/vimwiki/html'},
                   \  {'path': '~/work/betsmart/vimwiki/', 'path_html': '~/work/betsmart/vimwiki/html'}]

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
au VimLeave * :!/bin/sh -c "echo -ne \"\033[0m\""

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
