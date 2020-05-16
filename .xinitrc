xbindkeys
setxkbmap -option caps:escape
compton &
~/.fehbg
[[ -r ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
polybar bar &
exec bspwm
