#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color'
alias vi='vim'
alias t='todo'

alias http='python -m http.server'
alias json='python -m json.tool'

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

# Android
export PATH=$PATH:$HOME/android/tools:$HOME/android/platform-tools

# tmux
[ -n "$TMUX" ] && export TERM="screen-256color"

PS1='[\u@\h \W]\$ '

