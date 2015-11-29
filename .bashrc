#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
# turn off displays
alias doff='xset dpms force off'
# shutdown
alias tchau='systemctl poweroff'
# pacman update & upgrade
alias amen='sudo pacmatic -Syu'
# pacman install (needs argument)
alias s='sudo pacman -S'
# pacman update (needs argument)
alias u='sudo pacman -U'
PS1='[\u@\h \W]\$ '

# set PATH for texlive
# can be deleted. is set in profile.d/texlive.sh
#export PATH=/usr/local/texlive/2015/bin/x86_64-linux:$PATH
#export MANPATH=/usr/local/texlive/2015/texmf-dist/doc/man:$MANPATH
#export INFOPATH=/usr/local/texlive/2015/texmf-dist/doc/info:$INFOPATH
