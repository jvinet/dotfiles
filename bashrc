#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Vi all the things
set -o vi
# But make sure ^L, ^A, and ^E still work when in insert mode (muscle memory)
bind -m vi-insert "\C-l":clear-screen
bind -m vi-insert "\C-a":beginning-of-line
bind -m vi-insert "\C-e":end-of-line

# Locale
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# I type these things a lot
alias grep='grep --color'
alias vi='vim'
alias t='todo'
alias ll='ls -l'
alias r='ranger'
alias xc='xclip -selection clipboard'
alias xp='xclip -selection clipboard -o'
alias tc='tabs -16 ; tcalc '

# Python has some very handy treats
alias http='python -m http.server'
alias json='python -m json.tool'

# Quick AES encryption/decryption
alias enc='openssl aes-256-cbc -salt'
alias dec='openssl aes-256-cbc -d -salt'

if [ "`uname`" = "Linux" ]; then
	alias ls='ls --color'
	alias open='xdg-open'

	# Look for an active X display
	if [ -z "$DISPLAY" -a "`pgrep xinit`" != "" ]; then
		export DISPLAY=:0
	fi

	# Look for an active SSH agent - we lose it in tmux juggling sometimes
	pid="`pgrep ssh-agent`"
	if [ -n "$pid" ]; then
		export SSH_AGENT_PID=$pid
		dir=`/bin/ls -d1 /tmp/ssh-*/agent* | head -n 1`
		export SSH_AUTH_SOCK=$dir
	fi
else
	alias ls='ls -G'

	# Colorize Mac/BSD ls output
	export CLICOLOR=1
	export LSCOLORS=ExGxFxdxCxDxDxBxBxacac
fi

export PATH=$PATH:$HOME/bin:$HOME/.local/bin

# Perl
export PATH=$PATH:/usr/bin/vendor_perl

# Ruby
export PATH=$PATH:$HOME/.gem/ruby/1.9.1/bin:$HOME/.gem/ruby/2.0.0/bin

# Node
export PATH=$PATH:$HOME/node_modules/.bin

# Go
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# Android
export PATH=$PATH:$HOME/android/tools:$HOME/android/platform-tools

# Preferred applications
export EDITOR=vim
export PAGER=less
export BROWSER=firefox
export TERMINAL=terminator

# Lua: easy switching between 5.1 and 5.2
function setlua() {
	if [ "$1" = "" ]; then
		echo "usage: setlua <version>"
		echo "   ex: setlua 5.1"
		return
	fi
	export LUA_HOME="$HOME/.luarocks/share/lua/$1"
	export LUA_PATH="./?.lua;/usr/share/lua/$1/?.lua;/usr/share/lua/$1/?/init.lua;/usr/lib/lua/$1/?.lua;/usr/lib/lua/$1/?/init.lua"
	export LUA_PATH="$LUA_PATH;$LUA_HOME/?.lua;$LUA_HOME/?/init.lua;$LUA_HOME/?.lua;$LUA_HOME/?/init.lua"
	export LUA_CHOME="$HOME/.luarocks/lib/lua/$1"
	export LUA_CPATH="./?.so;/usr/lib/lua/$1/?.so;/usr/lib/lua/$1/loadall.so"
	export LUA_CPATH="./?.so;$LUA_CHOME/?.so;$LUA_CHOME/loadall.so"
	if [ "$1" = "5.1" ]; then
		alias lua='lua5.1'
		alias luac='luac5.1'
		alias luarocks='luarocks-5.1'
	elif [ "$1" = "5.2" ]; then
		unalias lua 2>/dev/null
		unalias luac 2>/dev/null
		unalias luarocks 2>/dev/null
	fi
}
setlua 5.1

# tmux / color terms
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM="screen-256color"

PS1='[\u@\h \W]\$ '

