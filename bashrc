#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color'
alias vi='vim'
alias t='todo'

if [ "`uname`" = "Linux" ]; then
	alias ls='ls --color'
	alias open='xdg-open'

	# Look for an active X display
	if [ "`pgrep xinit`" != "" ]; then
		export DISPLAY=:0
	fi

	# Look for an active SSH agent
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

export PATH=$PATH:$HOME/bin
export EDITOR=vim

# tmux
[ -n "$TMUX" ] && export TERM="screen-256color"

PS1='[\u@\h \W]\$ '
