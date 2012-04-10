#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color'

alias t='todo'
alias open='xdg-open'

# tmux
[ -n "$TMUX" ] && export TERM="screen-256color"

PS1='[\u@\h \W]\$ '
