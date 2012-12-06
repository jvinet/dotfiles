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
