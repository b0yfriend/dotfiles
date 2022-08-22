# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.
stty -ixon
alias ls='ls --classify --color=always'
alias less='less -r'
alias open='xdg-open'
export PS1="\[\e[0;33m\]❯ \[\e[0m\]"
export RANGER_LOAD_DEFAULT_RC=FALSE
CDPATH=".:$HOME"

aur() {
	local start_dir=$PWD
	cd /home/anton/aur
	for package_name; do
		git clone "https://aur.archlinux.org/${package_name}.git"
	done
	cd "$start_dir"
}

_in_pty() (
	[[ $(tty) = */pts/* ]]
)

_in_interactive_mode() {
	[[ -n $PS1 ]]
}

_tmux_exists() {
	command -v tmux >/dev/null 2>&1
}

_in_tmux() {
	[[ -n $TMUX ]]
}

if _tmux_exists && _in_interactive_mode && _in_pty && ! _in_tmux; then
	# Auto-attach to tmux
	/home/anton/.bin/t
fi
