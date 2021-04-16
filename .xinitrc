~/.fehbg
xbindkeys
setxkbmap -option caps:escape
xmodmap ~/.Xmodmap
xinput --set-prop 'Cooler Master Technology Inc. MM710 Gaming Mouse' 'libinput Accel Speed' -1
[[ -r ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
picom -f --config /home/anton/.config/picom.conf &
polybar bar1 &
polybar bar2 &
greenclip daemon >/dev/null 2>&1 &
# Put display to sleep after 120 seconds of inactivity
xset dpms standby 120
exec bspwm
