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

alias grep='grep --color'
alias vi='vim'
alias t='todo'
alias ll='ls -l'
alias r='ranger'

alias http='python -m http.server'
alias json='python -m json.tool'

# Quick AES encryption/decryption
alias enc='openssl aes-256-cbc -salt'
alias dec='openssl aes-256-cbc -d -salt'

# "Remind In" - schedule a popup reminder in X minutes
rin() {
	if [ "$2" = "" ]; then
		echo "usage: rin <minutes> <text>"
		return
	fi
	if [ "`pgrep atd`" = "" ]; then
		echo "error: atd is not running"
		return
	fi	
	if [ "`which zenity`" = "" ]; then
		echo "error: zenity is not installed"
		return
	fi

	mins=$1
	shift
	if [ -x "/usr/bin/capslock_light" ]; then
		echo "/usr/bin/capslock_light on ; zenity --display=:0 --info --text=\"Reminder: $*\" ; /usr/bin/capslock_light off" | at now + $mins min
	else
		echo "zenity --display=:0 --info --text=\"Reminder: $*\"" | at now + $mins min
	fi
	atq
}

# I markdown things a lot, and they should look nice
md() {
	if [ "$2" = "" ]; then
		echo "usage: md <in.md> <out.html>"
		return
	fi

	echo '<meta charset="utf-8">' >$2
	echo '<link rel="stylesheet" href="http://jasonm23.github.io/markdown-css-themes/markdown8.css">' >>$2
	markdown <$1 >>$2
}

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
		export SSH_AGENT_PID=$pid
		export SSH_AUTH_SOCK=$dir
	fi
else
	alias ls='ls -G'

	# Colorize Mac/BSD ls output
	export CLICOLOR=1
	export LSCOLORS=ExGxFxdxCxDxDxBxBxacac
fi

export PATH=$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.gem/ruby/1.9.1/bin:$HOME/.gem/ruby/2.0.0/bin

# Preferred applications
export EDITOR=vim
export PAGER=less
export BROWSER=firefox
export TERMINAL=terminator

# Go
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# Lua
function setlua51() {	
	export LUA_HOME="$HOME/.luarocks/share/lua/5.1"
	export LUA_PATH="./?.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;/usr/lib/lua/5.1/?.lua;/usr/lib/lua/5.1/?/init.lua"
	export LUA_PATH="$LUA_PATH;$LUA_HOME/?.lua;$LUA_HOME/?/init.lua;$LUA_HOME/?.lua;$LUA_HOME/?/init.lua"
	export LUA_CHOME="$HOME/.luarocks/lib/lua/5.1"
	export LUA_CPATH="./?.so;/usr/lib/lua/5.1/?.so;/usr/lib/lua/5.1/loadall.so"
	export LUA_CPATH="./?.so;$LUA_CHOME/?.so;$LUA_CHOME/loadall.so"
}
function setlua52() {
	export LUA_HOME="$HOME/.luarocks/share/lua/5.2"
	export LUA_PATH="./?.lua;/usr/share/lua/5.2/?.lua;/usr/share/lua/5.2/?/init.lua;/usr/lib/lua/5.2/?.lua;/usr/lib/lua/5.2/?/init.lua"
	export LUA_PATH="$LUA_PATH;$LUA_HOME/?.lua;$LUA_HOME/?/init.lua;$LUA_HOME/?.lua;$LUA_HOME/?/init.lua"
	export LUA_CHOME="$HOME/.luarocks/lib/lua/5.2"
	export LUA_CPATH="./?.so;/usr/lib/lua/5.2/?.so;/usr/lib/lua/5.2/loadall.so"
	export LUA_CPATH="./?.so;$LUA_CHOME/?.so;$LUA_CHOME/loadall.so"
}
setlua51

# Android
export PATH=$PATH:$HOME/android/tools:$HOME/android/platform-tools

# tmux / color terms
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM="screen-256color"

PS1='[\u@\h \W]\$ '

