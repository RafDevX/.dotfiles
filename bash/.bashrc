#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
source .aliases

export _JAVA_AWT_WM_NONREPARENTING=1
export CVS_RSH=ssh

if [ "$(tty)" = "/dev/tty1" ]; then
	exec startx
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
