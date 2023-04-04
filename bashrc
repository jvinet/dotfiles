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

# Large command history
export HISTSIZE=10000
# Don't remember duplicate commands, or commands starting with a space
export HISTCONTROL=ignoreboth

# Directory bookmarks
export CDPATH=.:~/.marks/
function mark() {
	ln -sr "$(pwd)" ~/.marks/"$1"
}

# I type these things a lot
alias u='cd ..'
alias grep='grep --color'
alias vi='nvim'
alias vim='nvim'
alias ll='ls -lh'
alias lt='ls -lhtr'
alias tc='tabs -16 ; tcalc '
alias op='netstat -tanl | grep LISTEN | sort'
alias opp='lsof -P -n -i tcp -s TCP:LISTEN'
alias gst='git status -uno'
alias r='ranger_cd'
alias nsum='awk "{ sum += \$1 } END { print sum }"'
alias json2csv="jq -r '(map(keys) | add | unique) as \$cols | map(. as \$row | \$cols | map(\$row[.])) as \$rows | \$cols, \$rows[] | @csv'"

cconv() {
	curl "https://free.currconv.com/api/v7/convert?q=$1_$2&compact=ultra&apiKey=3cb732c0bde799db1673"
}

ranger_cd() {
	# https://github.com/ranger/ranger/blob/master/examples/shell_automatic_cd.sh
	temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
	ranger --choosedir="$temp_file" -- "${@:-$PWD}"
	if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
		cd -- "$chosen_dir"
	fi
	rm -f -- "$temp_file"
}

if [ -n "$WAYLAND_DISPLAY" ]; then
	alias xc='wl-copy'
	alias xp='wl-paste'
else
	alias xc='xclip -selection clipboard'
	alias xp='xclip -selection clipboard -o'
fi

# Python has some very handy treats
alias http='python3 -m http.server'
alias json='python3 -m json.tool'

# Quick encryption/decryption
#alias enc='openssl aes-256-cbc -pbkdf2 -salt'
#alias dec='openssl aes-256-cbc -pbkdf2 -salt -d'

alias dos2unix="awk '{ sub(\"\r$\", \"\"); print }'"
alias unix2dos="awk 'sub(\"$\", \"\r\")'"

if [ "`uname`" = "Linux" ]; then
	alias ls='ls --color'
	if [ "`uname -o`" = "Android" ]; then
		alias open='termux-open'
	else
		alias open='xdg-open'
	fi

	# Look for an active X display
	if [ -z "$DISPLAY" -a "`pgrep xinit`" != "" ]; then
		export DISPLAY=:0
	fi

	# Look for an active SSH agent - we lose it in tmux juggling sometimes.
	# If one isn't found, start it.
	if [ "`uname -o`" = "Android" ]; then
		# Use the Termux-provided facility to hunt for an active agent.
		source $HOME/../usr/bin/source-ssh-agent
	else
		pid="`pgrep ssh-agent`"
		if [ -n "$pid" ]; then
			export SSH_AGENT_PID=$pid
			dir=`/bin/ls -d1 /tmp/ssh-*/agent* | head -n 1`
			export SSH_AUTH_SOCK=$dir
		else
			eval `ssh-agent`
		fi
	fi

	# Look for the Sway IPC socket - we lose it in tmux juggling.
	pid=`pgrep -x sway`
	if [ -n "$pid" ]; then
		export SWAYSOCK=/run/user/`id -u`/sway-ipc.`id -u`.$pid.sock

		# Yep, you guessed it - we also lose the DBus session.
		#
		# We don't look at the primary 'sway' process, because someone (dbus?)
		# is starting it in a way that's munging the perms in /proc/<pid> such
		# thwe we can't read them, only root.
		pid=`pgrep -x swayidle`
		if [ -n "$pid" ]; then
			ds=`xargs -n 1 -0 < /proc/$pid/environ | grep DBUS_SESSION_BUS_ADDRESS`
			if [ "$ds" ]; then
				eval export $ds
			fi
			unset ds
		fi
	fi
else
	alias ls='ls -G'
	alias firefox='open -a Firefox'

	# Colorize Mac/BSD ls output
	export CLICOLOR=1
	export LSCOLORS=ExGxFxdxCxDxDxBxBxacac
fi

export PATH=$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/sbin

# Perl
export PATH=$PATH:/usr/bin/vendor_perl

# Ruby
export PATH=$PATH:$HOME/.gem/ruby/1.9.1/bin:$HOME/.gem/ruby/2.0.0/bin

# Node
export PATH=$PATH:$HOME/node_modules/.bin
if [ "`uname`" = "Darwin" ]; then
	export NODE_PATH=/usr/local/lib/node_modules
else
	export NODE_PATH=$NODE_PATH:/usr/lib/node_modules
fi

# Nim
export PATH=$PATH:$HOME/.nimble/bin

# Go
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

# Nim
export PATH=$PATH:$HOME/.nimble/bin

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# Android
export PATH=$PATH:$HOME/android/tools:$HOME/android/platform-tools
export ANDROID_HOME=/usr/local/opt/android-sdk

# Pulumi
export PATH=$PATH:$HOME/.pulumi/bin

# Preferred applications
export EDITOR=vim
export PAGER='less -r'
export BROWSER=qutebrowser
export TERMINAL=alacritty
# Colorized manpages with bat(1)
if [ "`type -p bat`" ]; then
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Ask Firefox to enable Wayland support
export MOZ_ENABLE_WAYLAND=1

if [ -n "$WAYLAND_DISPLAY" ]; then
	export XDG_SESSION_TYPE=wayland
	export XDG_CURRENT_DESKTOP=sway
fi

# Some apps (eg: Electron) need this for Sway's system tray.
#[ -n "$WAYLAND_DISPLAY" ] && export XDG_CURRENT_DESKTOP=Unity

# tmux / color terms
export TERM=xterm-256color
#[ -n "$TMUX" ] && export TERM="screen-256color"

PS1='[\u@\h \W]\$ '

