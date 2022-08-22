~/.fehbg
xbindkeys
setxkbmap -option caps:escape
xmodmap ~/.Xmodmap
xinput --set-prop 'Cooler Master Technology Inc. MM710 Gaming Mouse' 'libinput Accel Speed' -1
[[ -r ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
picom --config /home/anton/.config/picom.conf &
polybar bar1 &
polybar bar2 &
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
fcitx -D &
greenclip daemon >/dev/null 2>&1 &
dunst >/dev/null 2>&1 &
xautolock -time 10 -locker "systemctl suspend" -detectsleep -corners '+-00' -cornerdelay 1 -cornerredelay 120 &
exec bspwm
