echo ""
echo "**** $HOME/.bashrc **** starts ****"
echo ""

# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "$(dircolors)"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# prettify (colours) man pages
# 31 – red
# 32 – green
# 33 – yellow
# 0 – reset/normal
# 1 – bold
# 4 – underlined
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

export TIME_STYLE=long-iso

if [ -f $HOME/.bash_aliases ]; then
  . $HOME/.bash_aliases
fi

# we run functions after aliases as some functions could surplant the aliases already defined
# we should look to remove the .bash_alias entry where a .bash_function conditional creates it. e.g. ls
if [ -f $HOME/.bash_functions ]; then
  . $HOME/.bash_functions
fi

echo ""
echo "**** $HOME/.bashrc **** ends ****"
echo ""

. "$HOME/.cargo/env"
