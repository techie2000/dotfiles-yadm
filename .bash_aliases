# shellcheck shell=bash

echo ""
echo "**** $HOME/.bash_aliases **** starts ****"
echo ""

# Personalisation
PERSONAL_ch=true    # ch[grp|own|mod]
PERSONAL_cat=true
PERSONAL_df=true
PERSONAL_diff=true
PERSONAL_grep=true  # [e|f]grep
PERSONAL_ls=true
PERSONAL_mkdir=true
PERSONAL_mount=true
PERSONAL_netstat=true
PERSONAL_rm=true
PERSONAL_tree=true
PERSONAL_wget=true


# The following lines will see your `ls' output colorized
export LS_OPTIONS='--color=auto'
eval "$(dircolors)"
if [[ "${PERSONAL_ls}" == "true" ]]
  then
        alias ls='ls $LS_OPTIONS --almost-all --classify --human-readable --inode -l --time-style=long-iso'
fi

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
if isPackageInstalled notify-send 
  then
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
# There is a namespace issue on Ubuntu, and bat is likely called batcat to avoid it
if [[ "${PERSONAL_cat}" == "true" ]]
  then
        if isPackageInstalled batcat 
	  then
		alias cat='batcat'
	  else
		alias cat='cat --show-all --number'
	fi
fi

alias   ..='cd ..'
alias cd..='cd ..' # Pickup and fix my common typo
alias   up='cd ..'
alias  up2='cd ../..'
alias  up3='cd ../../..'

#to do: bring the IS_WSL() under source control to re-enable this
#if [[ ${IS_WSL} == true ]]; then
#    # shellcheck disable=2139
#    alias cdh="cd /mnt/c/Users/${USER}" # Change to the home directory in Windows
#fi

alias bashaliases='vi $HOME/.bash_aliases && source $HOME/.bash_aliases'
alias bashfunctions='vi $HOME/.bash_functions && source $HOME/.bash_functions'

alias calc="bc -l"
alias countfiles=='find . -type f | wc -l'

if [[ "${PERSONAL_ch}" == "true" ]]
  then
        alias chgrp='chgrp --preserve-root' # safety net
	alias chmod='chmod --preserve-root' # safeyy net
	alias chown='chown --preserve-root' # safety net
fi

#to do: make m and n optional parameters of the call (i.e. move this to a function)
# pidstat flags
# run continuously every m seconds (for n times)
alias cpu='pidstat 5 3 --human'

# df options:
#   -h, --human-readable   : print sizes in powers of 1024 (e.g., 1023M)
#   -l, --local            : limit listing to local file systems
#   -T, --print-type       : print file system type
if [[ "${PERSONAL_df}" == "true" ]]
  then
        # shellcheck disable=SC2142
        alias df='df --human-readable --local --print-type | head -n 1 | awk '\''{print "\033[33m"$0"\033[39m"}'\''; df --human-readable --local --print-type | tail -n +2 |  sort --version-sort -k 7 | awk '\''BEGIN{FS=OFS="/"} {if (NF>1) {printf "%s", $1; for(i=2; i<NF; i++) printf "/%s", $i; printf "/\033[33m%s\033[39m\n", $NF} else print $0}'\'
fi

# to do: need to check that colordiff is installed and offer to install it if it isn't (and not set the alias if it's not)
# if it's not installed, alias this instead
# alias diff='diff --color --side-by-side'
if [[ "${PERSONAL_diff}" == "true" ]]
  then
        alias diff="colordiff --color=auto --report-identical-files --side-by-side"
fi

# df options:
#   -h, --human-readable   : print sizes in powers of 1024 (e.g., 1023M)
#   -l, --local            : limit listing to local file systems
#       --total            : elide all entries insignificant to available space,
#                              and produce a grand total
# grep options:
#   -E, --extended-regexp     PATTERNS are extended regular expressions
alias dut='\df --human-readable --local --total | grep --extended-regexp '"'total|Avail'"  # disk usage - total

# egrep option :
#    --colo[u]r[=WHEN]     : use markers to highlight the matching strings; WHEN is 'always', 'never', or 'auto'
if [[ "${PERSONAL_grep}" == "true" ]]
  then
        alias egrep='egrep --color=always'
fi

# fgrep option :
#    --colo[u]r[=WHEN]     : use markers to highlight the matching strings; WHEN is 'always', 'never', or 'auto'
if [[ "${PERSONAL_grep}" == "true" ]]
  then
        alias fgrep='fgrep --color=always'
fi

if isPackageInstalled git 
  then
	alias  ga='gad'
	alias gad='git add '
    	alias gbr='git branch '
    	alias gco='git commit'
    	alias  gc='gco'
    	alias  gd='gdi'
    	alias gdi='git diff'
    	alias gch='git checkout '
    	alias gita='gad'
    	alias gitc='gco'
    	alias gitd='gdi'
    	alias gitp='gpu'
    	alias gits='gst'
    	alias  gp='gpu'
    	alias gpu='git pull'
    	alias  gs='gst'
    	alias gst='git status'
    	alias got='git '          # typos
    	alias gut='git '          # typos
fi

# grep option :
#    --colo[u]r[=WHEN]     : use markers to highlight the matching strings; WHEN is 'always', 'never', or 'auto'
if [[ "${PERSONAL_grep}" == "true" ]]
  then
        alias grep='grep --color=always'
fi

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

# iostat flags
# -d m n = run continuously every m seconds for n times
# -t   = print the time of each report
alias io='iostat -d 5 --human -t'

# dmesg options:
#    -H, --human                 human-readable output
#    -L, --color[=<when>]        colorize messages (auto, always or never)
#    -w, --follow                wait for new messages
#    -W, --follow-new            wait and print only new messages
#    -x, --decode                decode facility and level to readable string
#        --time-format <format>  show timestamp using the given format:
#                                  [delta|reltime|ctime|notime|iso]
alias kernal='dmesg --color=always --decode --follow --human --time-format=iso'

# mkdir options:
#    -p, --parents     no error if existing, make parent directories as needed,
#                      with their file modes unaffected by any -m option.
#    -v, --verbose     print a message for each created directory
if [[ "${PERSONAL_mkdir}" == "true" ]]
  then
        alias mkdir='mkdir --parents --verbose'
fi

if [[ "${PERSONAL_mount}" == "true" ]]
  then
	if isPackageInstalled ccze
	  then
	    alias mount='mount|sort|column -t|ccze -A' # Make mount readable!
	  else
	    alias mount='mount|sort|column -t' # Make mount readable!
	fi
fi

if [[ "${PERSONAL_netstat}" == "true" ]]
  then
	alias netstat="netstat -tulanp"
fi

alias now='date +"%d-%m-%Y %T"'

alias path='echo -e ${PATH//:/\\n}'
# shellcheck disable=SC2142
alias passwordgenerator='cat /dev/urandom |tr -dc A-Za-z0-9 | head -c${1:-32};echo;'

# rm options:
#    -f, --force          : ignore nonexistent files and arguments, never prompt
#    -i                   : prompt before every removal
#    -I                   : prompt once before removing more than three files, or
#                             when removing recursively; less intrusive than -i,
#                             while still giving protection against most mistakes
#   -r, -R, --recursive   : remove directories and their contents recursively
#   --interactive[=WHEN]  : prompt according to WHEN: never, once (-I), or always (-i); without WHEN, prompt always
#   --preserve-root       : do not remove '/' (default)
#   --verbose explain what is being done
if [[ "${PERSONAL_rm}" == "true" ]]
  then
	alias rm='rm --force --interactive=once --preserve-root --recursive' # safety net
fi

alias spacehogs='du -hsx * | sort -rh | head -10'

if isPackageInstalled ccze  
  then
	alias syslog='tail -f /var/log/syslog | ccze'
  else
	alias syslog='tail -f /var/log/syslog'
fi

alias tailKernal='kernal'

if isPackageInstalled tmux
  then
	  alias tmux='tmux -2'
fi

# Display the directory structure better.
#   -A                     : Print ANSI lines graphic indentation lines
#   -C                     : Turn colorization on always
#   -F                     : Appends '/', '=', '*', '@', '|' or '>' as per ls -F
#   -h                     : Print the size in a more human-readable way
#   --dirsfirst            : List directories before files (-U disables)
if [[ "${PERSONAL_tree}" == "true" ]]
  then
        alias tree='tree --dirsfirst -A -C -F -h'
fi

alias untar='tar --extract --file --verbose -z'

if isPackageInstalled nvim
  then
	alias vim='nvim'
	alias  vi='nvim'
  else
	if isPackageInstalled nvim
	  then
		alias vi='vim'
	fi
fi

if [[ "${PERSONAL_wget}" == "true" ]]
  then
        alias wget='wget -c'
fi

# yadm = yet aother dotfile manager
if isPackageInstalled yadm
  then
	alias   y='yadm '
	alias yad='yadm add'
	alias ybr='yadm branch'
	alias yco='yadm commit'
	alias ydi='yadm diff'
	alias ych='yadm checkout '
	alias ypu='yadm pull'
	alias yst='yadm status'
fi


mkdir ~/.local/share/Trash
alias trash='mv --force -t ~/.local/share/Trash '
alias emptytrash='rm ~/.local/share/Trash/*'


echo ""
echo "**** $HOME/.bash_aliases **** ends ****"
echo ""
