#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ "`uname`" = "Linux" ]; then
	alias ls='ls --color'
else
	alias ls='ls -G'
fi

alias grep='grep --color'

alias t='todo'
alias open='xdg-open'

# Colorize Mac/BSD ls output
export CLICOLOR=1
export LSCOLORS=ExGxFxdxCxDxDxBxBxacac

export PATH=$PATH:$HOME/bin

# tmux
[ -n "$TMUX" ] && export TERM="screen-256color"

PS1='[\u@\h \W]\$ '
