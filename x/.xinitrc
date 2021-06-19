setxkbmap pt

export PATH=$HOME/bin:$PATH

xlayoutdisplay # need to wait for it to finish
blueman-manager & # control with blueman-applet
numlockx & # (*)
slstatus &
dunst &
flameshot &

# (*) = ampersand not needed, but I guess it makes loading faster

exec dwm
