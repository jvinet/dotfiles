" Vim color file
" Maintainer:  Judd Vinet <jvinet@gmail.com>
" Last Change: 2014-03-21

" Modified from "evening" scheme to honour a transparent background
" Original Maintainer: Bram Moolenaar <Bram@vim.org>

" First, remove all existing highlighting.
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "dusk"

hi Normal ctermbg=none ctermfg=White guifg=White guibg=grey20

" Groups used in the 'highlight' and 'guicursor' options default value.
hi ErrorMsg term=standout ctermbg=DarkRed ctermfg=White guibg=Red guifg=White
hi IncSearch term=reverse cterm=reverse gui=reverse
hi ModeMsg term=bold cterm=bold gui=bold
"hi StatusLine term=reverse,bold cterm=reverse,bold gui=reverse,bold
"hi StatusLineNC term=reverse cterm=reverse gui=reverse
hi VertSplit term=reverse cterm=reverse gui=reverse
hi Visual term=reverse ctermbg=DarkBlue guibg=grey60
hi VisualNOS term=underline,bold cterm=underline,bold gui=underline,bold
hi DiffText term=reverse cterm=bold ctermbg=Red gui=bold guibg=Red
hi Cursor guibg=Green guifg=Black
hi lCursor guibg=Cyan guifg=Black
hi Directory term=bold ctermfg=LightCyan guifg=Cyan
hi LineNr term=underline ctermfg=239 ctermbg=234 guifg=Grey
hi MoreMsg term=bold ctermfg=LightGreen gui=bold guifg=SeaGreen
hi NonText term=bold ctermfg=LightBlue gui=bold guifg=LightBlue guibg=grey30
hi Question term=standout ctermfg=LightGreen gui=bold guifg=Green
hi Search term=reverse ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
hi SpecialKey term=bold ctermfg=237 guifg=DarkGrey
hi Title term=bold ctermfg=LightMagenta gui=bold guifg=Magenta
hi WarningMsg term=standout ctermfg=LightRed guifg=Red
hi WildMenu term=standout ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
hi Folded term=standout ctermbg=237 ctermfg=27 guibg=LightGrey guifg=DarkBlue
hi FoldColumn term=standout ctermbg=237 ctermfg=27 guibg=Grey guifg=DarkBlue
hi DiffAdd term=bold ctermbg=DarkBlue guibg=DarkBlue
hi DiffChange term=bold ctermbg=DarkMagenta guibg=DarkMagenta
hi DiffDelete term=bold ctermfg=Blue ctermbg=DarkCyan gui=bold guifg=Blue guibg=DarkCyan
hi CursorColumn term=reverse ctermbg=Black guibg=grey40
hi CursorLine term=underline cterm=underline guibg=grey40
hi Comment ctermfg=Blue cterm=italic

" Groups for syntax highlighting
hi Constant term=underline ctermfg=Magenta guifg=#ffa0a0 guibg=grey5
hi Special term=bold ctermfg=LightRed guifg=Orange guibg=grey5
if &t_Co > 8
  hi Statement term=bold cterm=bold ctermfg=Yellow guifg=#ffff60 gui=bold
endif
hi Ignore ctermfg=DarkGrey guifg=grey20

" Tabs
hi TabLineFill ctermfg=255 ctermbg=255 cterm=underline
hi TabLine ctermfg=000 ctermbg=255
hi TabLineSel ctermfg=000 ctermbg=247 cterm=underline
hi TabTitle ctermfg=018 cterm=bold

" Extra visual indicators
hi ColorColumn ctermbg=234
hi TrailingWhitespace ctermbg=052
hi OverLength ctermbg=052

" For HTML (and markdown)
hi htmlTitle ctermfg=LightRed
hi htmlH1 ctermfg=LightCyan
hi htmlH2 ctermfg=LightCyan
hi htmlH3 ctermfg=LightCyan
hi htmlH4 ctermfg=LightCyan
hi htmlH5 ctermfg=LightCyan

" Cursorline - show a different bg color on the line being edited.
hi CursorLine ctermbg=017 cterm=none
augroup CursorLine
	au!
	au InsertEnter * setlocal cursorline
	au InsertLeave * setlocal nocursorline
augroup END

function! StatuslineColor()
	redraw
	let l:mode = mode()

	if     mode ==# "n" | let l:bg = '022' " normal
	elseif mode ==# "i" | let l:bg = '023' " insert
	elseif mode ==# "R" | let l:bg = '088' " replace
	elseif mode ==# "v" | let l:bg = '018' " visual
	elseif mode ==# "V" | let l:bg = '057' " v-line
	else                | let l:bg = '054' " v-block
	endif

	exec 'hi StatusLine ctermfg=015 ctermbg=' . l:bg

	" User1: filename
	" User2: separator
	" User3: modified indicator
	" User4: readonly indicator
	" User5: paste-mode indicator
	exec 'hi User1 ctermfg=015 ctermbg=' . l:bg
	exec 'hi User2 ctermfg=232 ctermbg=' . l:bg
	exec 'hi User3 ctermfg=184 ctermbg=' . l:bg
	exec 'hi User4 ctermfg=184 ctermbg=' . l:bg
	exec 'hi User5 ctermfg=184 ctermbg=' . l:bg
	return ''
endfunction

hi StatusLine   ctermfg=237 ctermbg=250 cterm=bold
hi StatusLineNC ctermfg=248 ctermbg=237 cterm=none
exec StatuslineColor()

" vim: sw=2
