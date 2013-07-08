#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color'
alias vi='vim'
alias t='todo'
alias ll='ls -l'

alias http='python -m http.server'
alias json='python -m json.tool'

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
	echo "zenity --display=:0 --info --text=\"$*\"" | at now + $mins min
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

export PATH=$PATH:$HOME/bin:$HOME/.gem/ruby/1.9.1/bin
export EDITOR=vim
export PAGER=less

# Go
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# Lua
export LUA_HOME="$HOME/.luarocks/share/lua/5.1"
export LUA_PATH="./?.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;/usr/lib/lua/5.1/?.lua;/usr/lib/lua/5.1/?/init.lua"
export LUA_PATH="$LUA_PATH;$LUA_HOME/?.lua;$LUA_HOME/?/init.lua;$LUA_HOME/?.lua;$LUA_HOME/?/init.lua"
export LUA_CHOME="$HOME/.luarocks/lib/lua/5.1"
export LUA_CPATH="./?.so;/usr/lib/lua/5.1/?.so;/usr/lib/lua/5.1/loadall.so"
export LUA_CPATH="./?.so;$LUA_CHOME/?.so;$LUA_CHOME/loadall.so"

# Android
export PATH=$PATH:$HOME/android/tools:$HOME/android/platform-tools

# tmux / color terms
export TERM=xterm-256color
[ -n "$TMUX" ] && export TERM="screen-256color"

PS1='[\u@\h \W]\$ '

