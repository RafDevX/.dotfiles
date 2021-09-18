#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
source .aliases

if [ "$(tty)" = "/dev/tty1" ]; then
	exec startx
fi
