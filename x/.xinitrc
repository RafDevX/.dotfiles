setxkbmap -option compose:rctrl pt

export PATH=$HOME/bin:$PATH

xlayoutdisplay # need to wait for it to finish
numlockx & # (*)
slstatus &
~/.fehbg &
xautolock -time 5 -locker "slock" -detectsleep -corners 000- &
dunst &
flameshot &
echo 'ping google.com & sleep 7 && kill $!' | bash & # trigger all network mechanisms

# (*) = ampersand not needed, but I guess it makes loading faster

exec dwm
