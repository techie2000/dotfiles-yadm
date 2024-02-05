# shellcheck shell=bash

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

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# shellcheck /usr/share/bash-completion/bash_completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
        function command_not_found_handle {
                # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
                   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
                   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
                else
                   printf "%s: command not found\n" "$1" >&2
                   return 127
                fi
        }
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# Load ~/.extra, ~/.bash_prompt, ~/.exports, ~/.aliases and ~/.functions
# ~/.extra can be used for settings you don’t want to commit
# we run functions after aliases as some functions could surplant the aliases already defined
# we should look to remove the .bash_alias entry where a .bash_function conditional creates it. e.g. ls
for file in ~/.{commonrc,bash_{aliases,functions},extra} ~/.shells/*; do
    [ -r "$file" ] && source "$file"
done
unset file


# Local customizations allowed and encouraged!
if [ -f ~/.bashrc_local ]; then
    source ~/.bashrc_local
fi

echo ""
echo "**** $HOME/.bashrc **** ends ****"
echo ""



# display useful system information when you open the terminal
clear

# to do: check if neofetch is installed and use that if it's installed
printf "\n"
printf "   %s\n" "IP ADDR: $(curl ifconfig.me)" | grep "IP ADDR"
printf "   %s\n" "USER: $(echo $USER)"
printf "   %s\n" "DATE: $(date)"
printf "   %s\n" "UPTIME: $(uptime -p)"
printf "   %s\n" "HOSTNAME: $(hostname -f)"
# printf "   %s\n" "CPU: $(awk -F: '/model name/{print $2}' | head -1)"
printf "   %s\n" "KERNEL: $(uname -rms)"
printf "   %s\n" "PACKAGES: $(dpkg --get-selections | wc -l)"
printf "   %s\n" "RESOLUTION: $(xrandr | awk '/\*/{printf $1" "}')"
printf "   %s\n" "MEMORY: $(free -m -h | awk '/Mem/{print $3"/"$2}')"
printf "\n"
sensors # to do: check it's installed
lsscsi # to do: check it's installed

# Check for favoutrite software and recomend to install missing items
printf "   %s\n" "what's at your disposal?"
if command -v batcat >/dev/null 2>&1; then
    printf "   %s\n" "batcat : installed"
else
    printf "   %s\n" "batcat : missing"
fi
if command -v exa >/dev/null 2>&1; then
    printf "   %s\n" "exa    : installed"
else
    printf "   %s\n" "exa    : missing"
fi



. "$HOME/.cargo/env"
