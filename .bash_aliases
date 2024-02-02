# shellcheck shell=bash

echo ""
echo "**** $HOME/.bash_aliases **** starts ****"
echo ""

# The following lines will see your `ls' output colorized
export LS_OPTIONS='--color=auto'
eval "$(dircolors)"
alias ls='ls $LS_OPTIONS --almost-all --classify --human-readable --inode -l --time-style=long-iso'

# to do: bring the IS_LINUX() under source control so it can be reused here
# update and upgrade
#if [[ "$IS_LINUX" == 'true' ]]; then
#  # Skip if root.
#  if [ $UID -ne 0 ]; then
#    alias aptup='sudo update'
#    # Note `install` is already a thing so don't use it as an alias.
#    alias aptins='sudo apt install'
#  fi
#fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
if command -v notify-send >/dev/null 2>&1; then
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

#  cat options:
#    -A, --show-all           equivalent to -vET
#    -b, --number-nonblank    number nonempty output lines, overrides -n
#    -e                       equivalent to -vE
#    -E, --show-ends          display $ at end of each line
#    -n, --number             number all output lines
#    -s, --squeeze-blank      suppress repeated empty output lines
#    -t                       equivalent to -vT
#    -T, --show-tabs          display TAB characters as ^I
#    -u                       (ignored)
#    -v, --show-nonprinting   use ^ and M- notation, except for LFD and TAB
#
# There is a namspace issue on Ubuntu, and bat is likely called batcat to avoid it
if command -v batcat >/dev/null 2>&1; then
  alias cat='batcat'
else
  alias cat='cat --show-all --number'
fi

alias   ..='cd ..'
alias cd..='cd ..' # Pickup and fix my common typo
alias   up='cd ..'
alias  up2='cd ../..'
alias  up3='cd ../../..'

#to do: bring the IS_WSL() under source control to renenable this
#if [[ ${IS_WSL} == true ]]; then
#    # shellcheck disable=2139
#    alias cdh="cd /mnt/c/Users/${USER}" # Change to the home directory in Windows
#fi

alias bashaliases='vi $HOME/.bash_aliases && source $HOME/.bash_aliases'
alias bashfunctions='vi $HOME/.bash_functions && source $HOME/.bash_functions'

alias calc="bc -l"
alias countfiles=='find . -type f | wc -l'

alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'

# df options:
#   -h, --human-readable   : print sizes in powers of 1024 (e.g., 1023M)
#   -k                     : like --block-size=1K
#   -T, --print-type       : print file system type
alias df="df --human-readable -k --print-type | sort -k 7"
alias diff="colordiff --color=auto --report-identical-files --side-by-side"

alias egrep='egrep --color=auto'

alias fgrep='fgrep --color=auto'

alias grep='grep --color=auto'

alias h='hist'
alias hist='history'
alias hg='histg'
alias histg='history | grep '

alias infoArchitecture='uname --machine'
alias infoCpu='infoProcessor'
alias infoHost='infoArchitecture; infoProcessor; infoKernelName; infoKernelRelease'
alias infoKernel='infoKernelName; infoKernelRelease'
alias infoKernelName='uname --kernel-name'
alias infoKernelRelease='uname --kernel-release'
alias infoProcessor='uname --processor'
alias infoProcessorDetailed='lscpu'

alias kernal='dmesg --color=always --time-format=iso'

#alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias mnt="mount|sort|column -t"

alias netstat="netstat -tulanp"
alias now='date +"%d-%m-%Y %T"'

alias path='echo -e ${PATH//:/\\n}'

alias rm='rm --recursive --force --interactive=once --preserve-root'

alias spacehogs='du -hsx * | sort -rh | head -10'
alias syslog='tail -f /var/log/syslog'

alias tailKernal='dmesg --color=always --time-format=iso --follow'

alias wget='wget -c'

echo ""
echo "**** $HOME/.bash_aliases **** ends ****"
echo ""
