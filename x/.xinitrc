setxkbmap pt

export PATH=$HOME/bin:$PATH

xlayoutdisplay # need to wait for it to finish
blueman-manager & # control with blueman-applet
numlockx & # (*)
slstatus &
~/.fehbg &
xautolock -time 5 -locker "slock" -detectsleep -corners 000- &
dunst &
flameshot &

# (*) = ampersand not needed, but I guess it makes loading faster

exec dwm
