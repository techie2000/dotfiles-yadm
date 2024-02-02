echo ""
echo "**** $HOME/.bash_aliases **** starts ****"
echo ""

# The following lines will see your `ls' output colorized
export LS_OPTIONS='--color=auto'
eval "$(dircolors)"
alias ls='ls $LS_OPTIONS --almost-all --classify --human-readable --inode -l --time-style=long-iso'

alias   ..='cd ..'
alias cd..='cd ..' # Pickup and fix my common typo

alias bashaliases='vi $HOME/.bash_aliases && source $HOME/.bash_aliases'
alias bashfunctions='vi $HOME/.bash_functions && source $HOME/.bash_functions'

alias calc="bc -l"
alias countfiles=='find . -type f | wc -l'

alias chgrp='chgrp --preserve-root'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'

alias df="df --human-readable --print-type | sort -k 7"
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
