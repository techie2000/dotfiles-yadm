#!/bin/bash

# shellcheck shell=bash

echo "**** $HOME/.bash_functions **** starts ****"

# to do: add function_installed+ to function definitions where it is missing (imports from older machines) 

# shellcheck source=./scripts/cecho.sh
# to do: bring this in from another box
# source "${BASH_SOURCE[0]%/*}/scripts/cecho.sh"  # colourful echo

# define variables here so the code below looks/feels neater and more manageable
RSYNC_SKIP_COMPRESS=3g2/3gp/3gpp/3mf/7z/aac/ace/amr/apk/appx/appxbundle/arc/arj/asf/avi/br/bz2/cab/crypt5/crypt7/crypt8/deb/dmg/drc/ear/gz/flac/flv/gpg/h264/h265/heif/iso/jar/jp2/jpg/jpeg/lz/lz4/lzma/lzo/m4a/m4p/m4v/mkv/msi/mov/mp3/mp4/mpeg/mpg/mpv/oga/ogg/ogv/opus/pack/png/qt/rar/rpm/rzip/s7z/sfx/svgz/tbz/tgz/tlz/txz/vob/webm/webp/wim/wma/wmv/xz/z/zip/zst

# Personalisation
PERSONAL_calendar=true
PERSONAL_hardlink=true
PERSONAL_ls=true

# keep track of what aliases and functiones we are defining so they can be detailed to the user at the end
alias_installed=()
function_installed=()

# check if a package is installed
# this is called by other functions below hence why it is not in alphabetical order
isPackageInstalled () {
        type "$1" &> /dev/null ;
}

#to do : once cecho is enabled, we can (re)introduce this code block
#backup() {
#    D=$(date +%Y-%m-%d-%H-%M-%S)
#    cp "$@" "$*"-"$D".bk
#    cecho -info "INFO: " -variable "$@" -info " copied to " -variable "$*-$D.bk"
#}

# to do : once cecho is installed, we can (re)introduce this code block
# unp hadles 'all' extracts, else setup syntax for common formats
#if command -v unp >/dev/null 2>&1; then
#   alias extract='unp'
#else
#   function extract () {
#        for archive in "$@"; do
#                if [ -f "$archive" ] ; then
#                        case "$archive" in
#                                *.tar)       tar        xvf  "$archive" ;;
#                                *.tar.bz2)   tar        xvjf "$archive" ;;
#                                *.tar.gz)    tar        xvzf "$archive" ;;
#                                *.tar.xz)    tar        Jxvf "$archive" ;;
#                                *.tar.Z)     tar        xzf  "$archive" ;;
#                                *.bz2)       bunzip2         "$archive" ;;
#                                *.rar)       rar        x    "$archive" ;;
#                                *.gz)        gunzip          "$archive" ;;
#                                *.tb2)       tar        xjf  "$archive" ;;
#                                *.tbz)       tar        xjf  "$archive" ;;
#                                *.tbz2)      tar        xvjf "$archive" ;;
#                                *.tgz)       tar        xvzf "$archive" ;;
#                                *.txz)       tar        Jxvf "$archive" ;;
#                                *.zip)       unzip           "$archive" ;;
#                                *.Z)         uncompress      "$archive" ;;
#                                *.7z)        7z         x    "$archive" ;;
#                                *)           cecho -error "ERROR: " -info "I don't know how to extract " -variable "$archive" ;;
#                        esac
#                else
#                        cecho -error "ERROR: " -variable "$archive" -info " is not a valid file!"
#                fi
#        done
#   }
#fi

# Options as of v1.0.8
#   -h --help           print this message
#   -d --decompress     force decompression
#   -z --compress       force compression
#   -k --keep           keep (don't delete) input files
#   -f --force          overwrite existing output files
#   -t --test           test compressed file integrity
#   -c --stdout         output to standard out
#   -q --quiet          suppress noncritical error messages
#   -v --verbose        be verbose (a 2nd -v gives more)
#   -L --license        display software version & license
#   -V --version        display software version & license
#   -s --small          use less memory (at most 2500k)
#   -1 .. -9            set block size to 100k .. 900k
#   --fast              alias for -1
#   --best              alias for -9
f_bzip() {

    FUNCTION_NAME="bzip";
    REQUIRED_PKG="bzip2";
    PACKAGE_NAME="bzip2";

    if isPackageInstalled "$REQUIRED_PKG"; then
        unset -f "f_$FUNCTION_NAME";
        alias "$FUNCTION_NAME"="$PACKAGE_NAME --best --keep";
        alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME --best --keep");
    fi

}
f_bzip


f_cal() {

    FUNCTION_NAME="cal";
    REQUIRED_PKG="ncal";
    PACKAGE_NAME="ncal";

    if [[ "${PERSONAL_calendar}" == "true" ]]; then
        if isPackageInstalled "$REQUIRED_PKG"; then
            unset -f "f_$FUNCTION_NAME";
            alias "$FUNCTION_NAME"="$PACKAGE_NAME -Mwy";
            alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME -Mwy");

            alias jan="$PACKAGE_NAME -m 01";
            alias_installed+=("jan=$PACKAGE_NAME -m 01");

            alias feb='ncal -m 02'
            alias_installed+=("feb=$PACKAGE_NAME -m 02");

            alias mar='ncal -m 03'
            alias_installed+=("mar=$PACKAGE_NAME -m 02");

            alias apr='ncal -m 04'
            alias_installed+=("apr=$PACKAGE_NAME -m 02");

            alias may='ncal -m 05'
            alias_installed+=("may=$PACKAGE_NAME -m 02");

            alias jun='ncal -m 06'
            alias_installed+=("jun=$PACKAGE_NAME -m 02");

            alias jul='ncal -m 07'
            alias_installed+=("jul=$PACKAGE_NAME -m 02");

            alias aug='ncal -m 08'
            alias_installed+=("aug=$PACKAGE_NAME -m 02");

            alias sep='ncal -m 09'
            alias_installed+=("sep=$PACKAGE_NAME -m 02");

            alias oct='ncal -m 10'
            alias_installed+=("oct=$PACKAGE_NAME -m 02");

            alias nov='ncal -m 11'
            alias_installed+=("nov=$PACKAGE_NAME -m 02");

            alias dec='ncal -m 12';  
            alias_installed+=("dec=$PACKAGE_NAME -m 12");
        else
            echo "cal is not installed :( Consider installing it!"
        fi
    fi

}
f_cal


# cd into a directory and list it's contents
cdls() {

        if [ $# -eq 0 ]
                then
                        echo "Please supply a directory/path"
                else
                        cd "$@" || return;
                        ls -l --almost-all --color --human-readable --inode --reverse --sort=time;
        fi

}
function_installed+=("cdls : cd into a directory and list it's contents")
# to do : once cecho is installed, replace original function above with this
# cd followed by ls
#cdls() {
#    DIR="$*"
#    # if no DIR given, go home
#    if [ $# -lt 1 ]; then
#        DIR=$HOME
#        cecho -warning "\nWARNING: " -info "You did not specify a directory for " -variable "${FUNCNAME[0]}" -info " so a default of " -variable "$DIR" -info " has been used.\n"
#    fi
#    builtin cd "${DIR}" &&
#    # use your preferred ls command command here. Consider configuring it as an alias to avoid touching this code
#    ls
#}

# Options (as of v3.2.3)
# --verbose, -v            increase verbosity
# --info=FLAGS             fine-grained informational verbosity
# --debug=FLAGS            fine-grained debug verbosity
# --stderr=e|a|c           change stderr output mode (default: errors)
# --quiet, -q              suppress non-error messages
# --no-motd                suppress daemon-mode MOTD
# --checksum, -c           skip based on checksum, not mod-time & size
# --archive, -a            archive mode is -rlptgoD (no -A,-X,-U,-N,-H)
# --no-OPTION              turn off an implied OPTION (e.g. # --no-D)
# --recursive, -r          recurse into directories
# --relative, -R           use relative path names
# --no-implied-dirs        don't send implied dirs with # --relative
# --backup, -b             make backups (see --suffix & --backup-dir)
# --backup-dir=DIR         make backups into hierarchy based in DIR
# --suffix=SUFFIX          backup suffix (default ~ w/o --backup-dir)
# --update, -u             skip files that are newer on the receiver
# --inplace                update destination files in-place
# --append                 append data onto shorter files
# --append-verify          --append w/old data in file checksum
# --dirs, -d               transfer directories without recursing
# --mkpath                 create the destination's path component
# --links, -l              copy symlinks as symlinks
# --copy-links, -L         transform symlink into referent file/dir
# --copy-unsafe-links      only "unsafe" symlinks are transformed
# --safe-links             ignore symlinks that point outside the tree
# --munge-links            munge symlinks to make them safe & unusable
# --copy-dirlinks, -k      transform symlink to dir into referent dir
# --keep-dirlinks, -K      treat symlinked dir on receiver as dir
# --hard-links, -H         preserve hard links
# --perms, -p              preserve permissions
# --executability, -E      preserve executability
# --chmod=CHMOD            affect file and/or directory permissions
# --acls, -A               preserve ACLs (implies # --perms)
# --xattrs, -X             preserve extended attributes
# --owner, -o              preserve owner (super-user only)
# --group, -g              preserve group
# --devices                preserve device files (super-user only)
# --copy-devices           copy device contents as regular file
# --specials               preserve special files
# -D                       same as --devices --specials
# --times, -t              preserve modification times
# --atimes, -U             preserve access (use) times
# --open-noatime           avoid changing the atime on opened files
# --crtimes, -N            preserve create times (newness)
# --omit-dir-times, -O     omit directories from # --times
# --omit-link-times, -J    omit symlinks from --times
# --super                  receiver attempts super-user activities
# --fake-super             store/recover privileged attrs using xattrs
#--sparse, -S             turn sequences of nulls into sparse blocks
# --preallocate            allocate dest files before writing them
# --write-devices          write to devices as files (implies --inplace)
# --dry-run, -n            perform a trial run with no changes made
# --whole-file, -W         copy files whole (w/o delta-xfer algorithm)
# --checksum-choice=STR    choose the checksum algorithm (aka --cc)
# --one-file-system, -x    don't cross filesystem boundaries
# --block-size=SIZE, -B    force a fixed checksum block-size
# --rsh=COMMAND, -e        specify the remote shell to use
# --rsync-path=PROGRAM     specify the rsync to run on remote machine
# --existing               skip creating new files on receiver
# --ignore-existing        skip updating files that exist on receiver
# --remove-source-files    sender removes synchronized files (non-dir)
# --del                    an alias for --delete-during
# --delete                 delete extraneous files from dest dirs
# --delete-before          receiver deletes before xfer, not during
# --delete-during          receiver deletes during the transfer
# --delete-delay           find deletions during, delete after
# --delete-after           receiver deletes after transfer, not during
# --delete-excluded        also delete excluded files from dest dirs
# --ignore-missing-args    ignore missing source args without error
# --delete-missing-args    delete missing source args from destination
# --ignore-errors          delete even if there are I/O errors
# --force                  force deletion of dirs even if not empty
# --max-delete=NUM         don't delete more than NUM files
# --max-size=SIZE          don't transfer any file larger than SIZE
# --min-size=SIZE          don't transfer any file smaller than SIZE
# --max-alloc=SIZE         change a limit relating to memory alloc
# --partial                keep partially transferred files
# --partial-dir=DIR        put a partially transferred file into DIR
# --delay-updates          put all updated files into place at end
# --prune-empty-dirs, -m   prune empty directory chains from file-list
# --numeric-ids            don't map uid/gid values by user/group name
# --usermap=STRING         custom username mapping
# --groupmap=STRING        custom groupname mapping
# --chown=USER:GROUP       simple username/groupname mapping
# --timeout=SECONDS        set I/O timeout in seconds
# --contimeout=SECONDS     set daemon connection timeout in seconds
# --ignore-times, -I       don't skip files that match size and time
# --size-only              skip files that match in size
# --modify-window=NUM, -@  set the accuracy for mod-time comparisons
# --temp-dir=DIR, -T       create temporary files in directory DIR
# --fuzzy, -y              find similar file for basis if no dest file
# --compare-dest=DIR       also compare destination files relative to DIR
# --copy-dest=DIR          ... and include copies of unchanged files
# --link-dest=DIR          hardlink to files in DIR when unchanged
# --compress, -z           compress file data during the transfer
# --compress-choice=STR    choose the compression algorithm (aka --zc)
# --compress-level=NUM     explicitly set compression level (aka --zl)
# --skip-compress=LIST     skip compressing files with suffix in LIST
# --cvs-exclude, -C        auto-ignore files in the same way CVS does
# --filter=RULE, -f        add a file-filtering RULE
# -F                       same as --filter='dir-merge /.rsync-filter'
#                          repeated: --filter='- .rsync-filter'
# --exclude=PATTERN        exclude files matching PATTERN
# --exclude-from=FILE      read exclude patterns from FILE
# --include=PATTERN        don't exclude files matching PATTERN
# --include-from=FILE      read include patterns from FILE
# --files-from=FILE        read list of source-file names from FILE
# --from0, -0              all *-from/filter files are delimited by 0s
# --protect-args, -s       no space-splitting; wildcard chars only
# --copy-as=USER[:GROUP]   specify user & optional group for the copy
# --address=ADDRESS        bind address for outgoing socket to daemon
# --port=PORT              specify double-colon alternate port number
# --sockopts=OPTIONS       specify custom TCP options
# --blocking-io            use blocking I/O for the remote shell
# --outbuf=N|L|B           set out buffering to None, Line, or Block
# --stats                  give some file-transfer stats
# --8-bit-output, -8       leave high-bit chars unescaped in output
# --human-readable, -h     output numbers in a human-readable format
# --progress               show progress during transfer
# -P                       same as --partial --progress
# --itemize-changes, -i    output a change-summary for all updates
# --remote-option=OPT, -M  send OPTION to the remote side only
# --out-format=FORMAT      output updates using the specified FORMAT
# --log-file=FILE          log what we're doing to the specified FILE
# --log-file-format=FMT    log updates using the specified FMT
# --password-file=FILE     read daemon-access password from FILE
# --early-input=FILE       use FILE for daemon's early exec input
# --list-only              list the files instead of copying them
# --bwlimit=RATE           limit socket I/O bandwidth
# --stop-after=MINS        Stop rsync after MINS minutes have elapsed
# --stop-at=y-m-dTh:m      Stop rsync at the specified point in time
# --write-batch=FILE       write a batched update to FILE
# --only-write-batch=FILE  like --write-batch but w/o updating dest
# --read-batch=FILE        read a batched update from FILE
# --protocol=NUM           force an older protocol version to be used
# --iconv=CONVERT_SPEC     request charset conversion of filenames
# --checksum-seed=NUM      set block/file checksum seed (advanced)
# --ipv4, -4               prefer IPv4
# --ipv6, -6               prefer IPv6
# --version, -V            print the version + other info and exit
# --help, -h (*)           show this help (* -h is help only on its own)
f_cp() {

    FUNCTION_NAME="cp";
    REQUIRED_PKG="rsync";
    PACKAGE_NAME="rsync";

    if isPackageInstalled "$REQUIRED_PKG"; then
        unset -f "f_$FUNCTION_NAME";
        # alias "$FUNCTION_NAME"="$PACKAGE_NAME --acls --atimes --compress --crtimes --devices --group --hard-links --links --owner --perms --partial --partial-dir=/tmp/ --preallocate --progress --recursive --skip-compress=$RSYNC_SKIP_COMPRESS --specials --stats --temp-dir=/tmp --times --xattrs";
        # crtimes seen not to work on this (debian?) version. Unsure if it Debian or the fact its v3.2.3 - as it works on Slackware v3.2.7
        alias "$FUNCTION_NAME"="$PACKAGE_NAME --acls --atimes --compress --devices --group --hard-links --links --owner --perms --partial --partial-dir=.rsync-partial --preallocate --progress --recursive --skip-compress=$RSYNC_SKIP_COMPRESS --specials --stats --times --xattrs";
        alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME --acls --atimes --compress --devices --group --hard-links --links --owner --perms --partial-dir=.rsync-partial --preallocate --progress --recursive --skip-compress=$RSYNC_SKIP_COMPRESS --specials --stats --times --xattrs");
    fi

}
f_cp

f_cpDryRun() {

    FUNCTION_NAME="cpDryRun";
    REQUIRED_PKG="rsync";
    PACKAGE_NAME="rsync";

    if isPackageInstalled "$REQUIRED_PKG"; then
        unset -f "f_$FUNCTION_NAME";
        # alias "$FUNCTION_NAME"="$PACKAGE_NAME --acls --atimes --compress --crtimes --devices --group --hard-links --links --list-only --owner --perms --partial --partial-dir=/tmp/ --preallocate --progress --recursive --skip-compress=$RSYNC_SKIP_COMPRESS --specials --stats --temp-dir=/tmp --times --xattrs";
        # crtimes seen not to work on this (debian?) version. Unsure if it Debian or the fact its v3.2.3 - as it works on Slackware v3.2.7
        alias "$FUNCTION_NAME"="$PACKAGE_NAME --acls --atimes --compress --devices --group --hard-links --links --list-only --owner --perms --partial-dir=.rsync-partial --preallocate --progress --recursive --skip-compress=$RSYNC_SKIP_COMPRESS --specials --stats --times --xattrs";
        alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME --acls --atimes --compress --devices --group --hard-links --links --list-only --owner --perms --partial-dir=.rsync-partial --preallocate --progress --recursive --skip-compress=$RSYNC_SKIP_COMPRESS --specials --stats --times --xattrs");
    fi

}
f_cpDryRun


# du options as ov v8.32 :
#  -0, --null            end each output line with NUL, not newline
#  -a, --all             write counts for all files, not just directories
#      --apparent-size   print apparent sizes, rather than disk usage; although
#                          the apparent size is usually smaller, it may be
#                          larger due to holes in ('sparse') files, internal
#                          fragmentation, indirect blocks, and the like
#  -B, --block-size=SIZE  scale sizes by SIZE before printing them; e.g.,
#                           '-BM' prints sizes in units of 1,048,576 bytes;
#                           see SIZE format below
#  -b, --bytes           equivalent to '--apparent-size --block-size=1'
#  -c, --total           produce a grand total
#  -D, --dereference-args  dereference only symlinks that are listed on the
#                          command line
#  -d, --max-depth=N     print the total for a directory (or file, with --all)
#                          only if it is N or fewer levels below the command
#                          line argument;  --max-depth=0 is the same as
#                          --summarize
#      --files0-from=F   summarize disk usage of the
#                          NUL-terminated file names specified in file F;
#                          if F is -, then read names from standard input
#  -H                    equivalent to --dereference-args (-D)
#  -h, --human-readable  print sizes in human readable format (e.g., 1K 234M 2G)
#      --inodes          list inode usage information instead of block usage
#  -k                    like --block-size=1K
#  -L, --dereference     dereference all symbolic links
#  -l, --count-links     count sizes many times if hard linked
#  -m                    like --block-size=1M
#  -P, --no-dereference  don't follow any symbolic links (this is the default)
#  -S, --separate-dirs   for directories do not include size of subdirectories
#      --si              like -h, but use powers of 1000 not 1024
#  -s, --summarize       display only a total for each argument
#  -t, --threshold=SIZE  exclude entries smaller than SIZE if positive,
#                          or entries greater than SIZE if negative
#      --time            show time of the last modification of any file in the
#                          directory, or any of its subdirectories
#      --time=WORD       show time as WORD instead of modification time:
#                          atime, access, use, ctime or status
#      --time-style=STYLE  show times using STYLE, which can be:
#                            full-iso, long-iso, iso, or +FORMAT;
#                            FORMAT is interpreted like in 'date'
#  -X, --exclude-from=FILE  exclude files that match any pattern in FILE
#      --exclude=PATTERN    exclude files that match PATTERN
#  -x, --one-file-system    skip directories on different file systems
#      --help     display this help and exit
#      --version  output version information and exit
#
# ncdu options
#  -h,--help                  This help message
#  -q                         Quiet mode, refresh interval 2 seconds
#  -v,-V,--version            Print version
#  -x                         Same filesystem
#  -e                         Enable extended information
#  -r                         Read only
#  -o FILE                    Export scanned directory to FILE
#  -f FILE                    Import scanned directory from FILE
#  -0,-1,-2                   UI to use when scanning (0=none,2=full ncurses)
#  --si                       Use base 10 (SI) prefixes instead of base 2
#  --exclude PATTERN          Exclude files that match PATTERN
#  -X, --exclude-from FILE    Exclude files that match any pattern in FILE
#  -L, --follow-symlinks      Follow symbolic links (excluding directories)
#  --exclude-caches           Exclude directories containing CACHEDIR.TAG
#  --exclude-kernfs           Exclude Linux pseudo filesystems (procfs,sysfs,cgroup,...)
#  --confirm-quit             Confirm quitting ncdu
#  --color SCHEME             Set color scheme (off/dark/dark-bg)
f_du() {

    FUNCTION_NAME="du";
    REQUIRED_PKG="ncdu";
    PACKAGE_NAME="ncdu";

    if isPackageInstalled "$REQUIRED_PKG"; then
        unset -f "f_$FUNCTION_NAME";
        alias "$FUNCTION_NAME"="$PACKAGE_NAME -2 --color dark --confirm-quit";
        alias_installed+=("$FUNCTION_NAME=$PACKAGE_NAME -2 --color dark --confirm-quit");

    else

        echo "$REQUIRED_PKG is not installed :( Consider installing it!";

        FUNCTION_NAME="du"; 
        REQUIRED_PKG="coreutils";
        PACKAGE_NAME="du";

        if isPackageInstalled "$REQUIRED_PKG"; then
            unset -f "$FUNCTION_NAME"; 
            #  -c, --total           produce a grand total
            #  -d, --max-depth=N     print the total for a directory (or file, with --all)
            #                          only if it is N or fewer levels below the command
            #                          line argument;  --max-depth=0 is the same as
            #                          --summarize
            #  -h, --human-readable  print sizes in human readable format (e.g., 1K 234M 2G)
            alias "$FUNCTION_NAME"="$PACKAGE_NAME --human-readable --max-depth=1 --total | grep total";
            alias_installed+=("$FUNCTION_NAME=$PACKAGE_NAME --human-readable --max-depth=1 --total | grep total");
        fi

    fi

}
f_du


# find a file by its inum
findi() {
        if [ $# -eq 0 ]
                then
                        echo "Please supply an inum"
                else
                        find . -inum "$1"
        fi
}
function_installed+=("findi : find a file by its inum")

# find the largest files in a directory
# du options :
#  --human-readable  : print sizes in human readable format (e.g., 1K 234M 2G)
#  --one-file-system : skip directories on different file systems
#  --summarize       : display only a total for each argument
function find_largest_files() {
    \du --human-readable --one-file-system --summarize ./* | sort -r -h | head -20
}


# find a file by its name
findf() {
        if [ $# -eq 0 ]
                then
                        echo "Please supply (part of) a filename"
                else
                        find . -iname "$1"
        fi
}
function_installed+=("findn : find a file by its name")


# find a directory by its name
findd() {
        if [ $# -eq 0 ]
                then
                        echo "Please supply (part of) a directory name"
                else
                        find . -type d -iname "$1"
        fi
}
function_installed+=("findd : find a directory by its name")


# find a file by its name
findf() {
        if [ $# -eq 0 ]
                then
                        echo "Please supply (part of) a filename"
                else
                        find . -type f -iname "$1"
        fi
}
function_installed+=("findf : find a file by its filename")


# Options (as of v0.3 RC2)
#  -V, --version         show program's version number and exit
#  -h, --help            show this help message and exit
#  -v, --verbose         Increase verbosity (repeat for more verbosity)
#  -n, --dry-run         Modify nothing, just print what would happen
#  -f, --respect-name    Filenames have to be identical
#  -p, --ignore-mode     Ignore changes of file mode
#  -o, --ignore-owner    Ignore owner changes
#  -t, --ignore-time     Ignore timestamps (when testing for equality)
#  -X, --respect-xattrs  Respect extended attributes
#  -m, --maximize        Maximize the hardlink count, remove the file with
#                        lowest hardlink cout
#  -M, --minimize        Reverse the meaning of -m
#  -O, --keep-oldest     Keep the oldest file of multiple equal files
#                        (lower precedence than minimize/maximize)
#  -x REGEXP, --exclude=REGEXP
#                        Regular expression to exclude files
#  -i REGEXP, --include=REGEXP
#                        Regular expression to include files/dirs
#  -s <num>[K,M,G], --minimum-size=<num>[K,M,G]
#                        Minimum size for files. Optional suffix
#                        allows for using KiB, MiB, or GiB
f_hardlinkMedia() {

    FUNCTION_NAME="hardlinkMedia";
    REQUIRED_PKG="hardlink";
    PACKAGE_NAME="hardlink";

    if [[ "${PERSONAL_hardlink}" == "true" ]] then

        if isPackageInstalled "$REQUIRED_PKG"; then
            unset -f "f_$FUNCTION_NAME";
            #alias $FUNCTION_NAME="$PACKAGE_NAME --cache-size 1G --ignore-mode --ignore-owner --ignore-time --io-size 1G --keep-oldest --minimum-size 1K --verbose --include \".*\.(avi|flac|gif|jpe?g|m[ok]v|mp[3-4]|png|tiff)$"";
            alias "$FUNCTION_NAME"="$PACKAGE_NAME --cache-size 1G --ignore-mode --ignore-owner --ignore-time --io-size 1G --keep-oldest --minimum-size 1K --verbose --include \".*\.(avi|flac|gif|jpe?g|m[ok]v|mp[3-4]|png|tiff)$\""; 
            #alias_installed+=("$FUNCTION_NAME=$PACKAGE_NAME --cache-size 1G --ignore-mode --ignore-owner --ignore-time --io-size 1G --keep-oldest --minimum-size 1K --verbose --include \".*\.(avi|flac|gif|jpe?g|m[ok]v|mp[3-4]|png|tiff)$\"");
        fi

    fi

}
f_hardlinkMedia

f_hardlinkMediaDryRun() {

    FUNCTION_NAME="hardlinkMediaDryRun";
    REQUIRED_PKG="hardlink";
    PACKAGE_NAME="hardlink";

    if [[ "${PERSONAL_hardlink}" == "true" ]] then

        if isPackageInstalled "$REQUIRED_PKG"; then
            unset -f "f_$FUNCTION_NAME";
            #alias $FUNCTION_NAME='"$PACKAGE_NAME" --cache-size 1G --ignore-mode --ignore-owner --ignore-time --io-size 1G --keep-oldest --minimum-size 1K --verbose --dry-run --include ".*\.(avi|flac|gif|jpe?g|m[ok]v|mp[3-4]|png|tiff)$"';
            alias "$FUNCTION_NAME"="$PACKAGE_NAME --cache-size 1G --ignore-mode --ignore-owner --ignore-time --io-size 1G --keep-oldest --minimum-size 1K --verbose --dry-run --include \".*\.(avi|flac|gif|jpe?g|m[ok]v|mp[3-4]|png|tiff)$\"";
            alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME --cache-size 1G --ignore-mode --ignore-owner --ignore-time --io-size 1G --keep-oldest --minimum-size 1K --verbose --dry-run --include \".*\.(avi|flac|gif|jpe?g|m[ok]v|mp[3-4]|png|tiff)$\"");
        fi

    fi

}
f_hardlinkMediaDryRun


# Options (as of v3.0.5)
# -C --no-color                   Use a monochrome color scheme
# -d --delay=DELAY                Set the delay between updates, in tenths of seconds
# -F --filter=FILTER              Show only the commands matching the given filter
# -h --help                       Print this help screen
# -H --highlight-changes[=DELAY]  Highlight new and old processes
# -M --no-mouse                   Disable the mouse
# -p --pid=PID[,PID,PID...]       Show only the given PIDs
# -s --sort-key=COLUMN            Sort by COLUMN in list view (try --sort-key=help for a list)
# -t --tree                       Show the tree view (can be combined with -s)
# -u --user[=USERNAME]            Show only processes for a given user (or $USER)
# -U --no-unicode                 Do not use unicode but plain ASCII
# -V --version                    Print version info
f_htop() {

    FUNCTION_NAME="htop";
    REQUIRED_PKG="htop";
    PACKAGE_NAME="htop";

    if isPackageInstalled "$REQUIRED_PKG"; then
        unset -f "f_$FUNCTION_NAME";
        alias "$FUNCTION_NAME"="$PACKAGE_NAME --delay=10 --highlight-changes=5";
        alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME --delay=10 --highlight-changes=5");
    fi

}
f_htop


f_iftop() {

    FUNCTION_NAME="iftop";
    REQUIRED_PKG="iftop";
    PACKAGE_NAME="iftop";

    if isPackageInstalled "$REQUIRED_PKG"; then
        unset -f "f_$FUNCTION_NAME";
        alias "$FUNCTION_NAME"="$PACKAGE_NAME -pP -o source -F 192.168.1.0/24";
        alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME -pP -o source -F 192.168.1.0/24");
    fi

}
f_iftop


# generate a random GUID
if command -v curl >/dev/null 2>&1; then
    generate_guid() {
        curl givemeguid.com
    }
fi


# to do : once cecho is installed, we can (re)introduce this code block
# generate a random number
#if command -v curl >/dev/null 2>&1; then
#    generate_random_number() {
#        cecho -info "Generating a random integer between " -variable "1" -info " and " -variable "1000"
#        curl "https://www.random.org/integers/?num=1&min=1&max=1000&col=1&base=10&format=plain&rnd=new"
#    }
#fi


# to do : once cecho is installed, we can (re)introduce this code block
# show animated gif in the terminal
#if command -v curl >/dev/null 2>&1; then
#    get_animated_gif() {
#        SEARCHTERM=$1
#        if [ -z "$SEARCHTERM" ]; then
#            cecho -warning "\nWARNING: " -info "You did not supply a search term so a sample of " -variable "penguin" -info " was used."
#            curl gif.xyzzy.run/penguin
#        else
#            curlgif.xyzzy.run/"$SEARCHTERM"
#       fi
#    }
#fi


# to do : once cecho is installed, we can (re)introduce this code block
# show crypto
#if command -v curl >/dev/null 2>&1; then
#    get_crypto() {
#        CURRENCY=$1
#        if [ -z "$CURRENCY" ]; then
#            curl rate.sx
#            cecho -warning "\nWARNING: " -info "You did not specify a currency for " -variable "${FUNCNAME[0]}" -info " so by default you get the top 10 currencies.\n"
#            cecho -info "If you specify a currency (e.g. BTC, ETH, XRP, DOGE), you will see a graph of recent movements in that currency's valuation.\n"
#        else
#            curl rate.sx/"$CURRENCY"
#            curl rate.sx
#        fi
#    }
#fi


# tell me a dad joke
if command -v curl >/dev/null 2>&1; then
    get_joke() {
        curl https://icanhazdadjoke.com
    }
fi


# to do : once cecho is installed, we can (re)introduce this code block
# Get the news on given topic (term)
#if command -v curl >/dev/null 2>&1; then
#    get_news() {
#        TERM=$1
#        if [ -z "$TERM" ]; then
#            curl gb.getnews.tech
#            cecho -warning "WARNING: " -info "You did not specify a search term for " -variable "${FUNCNAME[0]}" -info " to show, so a generic default has been applied.\n"
#            cecho -info "example search terms: " -purple "trump" -info " or " -purple "category={business|entertainment|general|health|acience|sports│technology}" -info " or " -purple "mass+shooting\n"
#            cecho -info "You can restrict the number of articles to say 5 by adding " -purple ",n=5" -info "to your search term.\n"
#        else
#            curl gb.getnews.tech/"$TERM"
#        fi
#    }
#fi


# to do : once cecho is installed, we can (re)introduce this code block
# get stock price for supplied ticker
#if command -v curl >/dev/null 2>&1; then
#    get_stock_price() {
#        TICKER=$1
#        if [ -z "$TICKER" ]; then
#            TICKER=MSFT
#            curl terminal-stocks.shashi.dev/"$TICKER"
#            cecho -warning "WARNING: " -info "You did not specify a ticker for " -variable "${FUNCNAME[0]}" -info " to show, so a generic default of " -variable "$TICKER" -info " has been used for demo purposes.\n"
#        else
#             curl terminal-stocks.shashi.dev/"$TICKER"
#        fi
#    }
#fi

# to do : once cecho is installed, we can (re)introduce this code block
# get stock price for supplied ticker
#if command -v curl >/dev/null 2>&1; then
#    get_stock_price_history() {
#        TICKER=$1
#        if [ -z "$TICKER" ]; then
#            TICKER=MSFT
#            curl terminal-stocks.shashi.dev/historical/"$TICKER"
#            cecho -warning "WARNING: " -info "You did not specify a ticker for " -variable "${FUNCNAME[0]}" -info " to show, so a generic default of " -variable "$TICKER" -info " has been used for demo purposes.\n"
#        else
#             curl terminal-stocks.shashi.dev/historical/"$TICKER"
#        fi
#    }
#fi

# to do : once cecho is installed, we can (re)introduce this code block
# show 3 day weather forecast (shows London by default)
#if command -v curl >/dev/null 2>&1; then
#    get_weather() {
#        LOCATION=$1
#        if [ -z "$LOCATION" ]; then
#            LOCATION=London
#            curl wttr.in/"$LOCATION"?u
#            cecho -info "INFO: You did not specify a location parameter for " -variable "${FUNCNAME[0]}" -info " so " -variable "$LOCATION" -info " has been shown by default\n"
#            cecho -info "You can get a larger orerview of current conditions at " -variable "https://v3.wttr.in/$LOCATION\n"
#        else
#            curl wttr.in/"$LOCATION"?u
#        fi
#        curl wttr.in/Moon
#        cecho -info "\nINFO: You can get a larger orerview of current conditions at " -variable "https://v3.wttr.in/$LOCATION\n"
#    }
#fi


# Show cpu utilisation
# Note, this is only a function because I couldn't escape the alias correctly
infoCpuUtilisation() {

     top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}'

}
function_installed+=("infoCpuUtilisation : Show current CPU utilisation")


# Details about the OS  
infoDistro() {

        if [[ $(uname --kernel-name) != 'Linux' ]]
                then
                        retval='unknown'
                else
                        if [ -n "$(command -v lsb_release)" ]; then
                                retval="$(lsb_release -s -d)"
                        elif [ -f "/etc/os-release" ]; then
                                retval="$(grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '="')"
                        elif [ -f "/etc/debian_version" ]; then
                                retval="Debian $(cat /etc/debian_version)"
                        elif [ -f "/etc/redhat-release" ]; then
                                retval="$(cat /etc/redhat-release)"
                        else
                                retval="$(uname -s) $(uname -r)"
                        fi
        fi

        echo "$retval"

}
function_installed+=("infoDistro : Details about the OS")


# TO DO : Put a check for package name being supplied (so turn into a function) , and when running update/upgrade, warn of the consequences and offer to contine/breakout.
#         add alias_installed output
case $(infoDistro) in
    CentOS*|Fedora*|RedHatEnterpriseServer* )
        alias installpkg="yum install" ;
        alias removepkg="yum remove" ;
        aliad updatepkg="yum update" ;
        alias update="yum -y update" ;
        alias upgrade="yum upgrade" ;
        ;;
    Slackware* )
        alias installpkg="upgradepkg --install-new" ;
        alias removepkg="removepkg" ;
        alias updatepkg="upgradepkg" ;
        ;;
    Ubuntu*|Debian*|Raspbian* )
        alias installpkg="apt-get install --yes" ;
        alias removepkg="apt-get remove --yes" ;
        alias update="apt-get update" ;
        alias updatepkg="apt-get update" ;
        alias upgrade="apt-get upgrade" ;
        ;;
esac


#to do: add further aliases for publicIp and externalIp
# what's my external facing IP ?
f_infoExternalIp() {

    FUNCTION_NAME="infoExternalIp";
    REQUIRED_PKG="curl";
    PACKAGE_NAME="curl";

    if isPackageInstalled "$REQUIRED_PKG"; then
        unset -f "f_$FUNCTION_NAME";
        alias "$FUNCTION_NAME"="$PACKAGE_NAME icanhazip.com";
        alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME icanhazip.com");
    else
        echo "$REQUIRED_PKG is not installed :( Consider installing it!"
    fi

}
f_infoExternalIp


# what's my internal IP addresses
# f_infoInternalIp() {
	FUNCTION_NAME="infoInternalIp";
	REQUIRED_PKG="ifconfig";
	PACKAGE_NAME="ifconfig";

	if isPackageInstalled "$REQUIRED_PKG"; then
		unset -f "f_$FUNCTION_NAME";
		alias "$FUNCTION_NAME"="$PACKAGE_NAME -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'";
		alias_installed+=("$FUNCTION_NAME"="PACKAGE_NAME -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'");
	fi
}


# identify the vendor for a given mac
infoMacVendor() {

         if [ $# -eq 0 ]
                 then
                         echo "Please supply a valid mac address"
                 else
                         if [[ "$1" =~ ^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})|([0-9a-fA-F]{4}\\.[0-9a-fA-F]{4}\\.[0-9a-fA-F]{4})$ ]]
                                 then
                                        curl http://api.macvendors.com/"$1"
                                 else
                                        echo "$1 is an invalid MAC address"
                         fi
          fi

}
function_installed+=("infoMacVendor : identify the vendor for a given mac addrerss")


# Show memory used/available 
# Note, this is only a function because I couldn't escape the alias correctly
infoMemory() {

    free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'

}
function_installed+=("infoMemory : Show memory used/available")


# Show memory used/available
# Note, this is only a function because I couldn't escape the alias correctly 
infoMemoryProcesses() {

    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head

}
function_installed+=("infoMemoryProcesses : Show memory (and CPU) utilisation for processes")


# Detect OS and Services
infoOsAndServicesLevel1() {

    FUNCTION_NAME="infoOsAndServicesLevel1";
    REQUIRED_PKG="nmap";
    PACKAGE_NAME="nmap";

    if isPackageInstalled "$REQUIRED_PKG"; then
        if [ $# -eq 0 ]
                then
                        echo "Please supply an ip address or servername"
                else
                        nmap -A "$1"
        fi
    fi

}
function_installed+=("infoOsAndServicesLevel1 : Detect OS and Services")


# Detect OS and Services (More aggressive Service Detection)
infoOsAndServicesLevel2() {

    FUNCTION_NAME="infoOsAndServicesLevel2";
    REQUIRED_PKG="nmap";
    PACKAGE_NAME="nmap";

    if isPackageInstalled "$REQUIRED_PKG"; then
        if [ $# -eq 0 ]
                then
                        echo "Please supply an ip address or servername"
                else
                        nmap -sV --version-intensity 5 "$1"
        fi
    fi

}
function_installed+=("infoOsAndServicesLevel2 : Detect OS and Services (More aggressive Service Detection)")


# Detect OS and Services (Digging deeper with NSE Scripts)
infoOsAndServicesLevel3() {

    FUNCTION_NAME="infoOsAndServicesLevel3";
    REQUIRED_PKG="nmap";
    PACKAGE_NAME="nmap";

    if isPackageInstalled "$REQUIRED_PKG"; then
        if [ $# -eq 0 ]
                then
                        echo "Please supply an ip address or servername"
                else
                        nmap -sV -sC "$1"
        fi
    fi

}
function_installed+=("infoOsAndServicesLevel3 : Detect OS and Services (Digging deeper with NSE Scripts)")


# Detect OS and Services (Digging deeper with NSE Scripts)
infoOsVunerabilities() {

    FUNCTION_NAME="infoOsVunerabilities";
    REQUIRED_PKG="nmap";
    PACKAGE_NAME="nmap";

    if isPackageInstalled "$REQUIRED_PKG"; then
        if [ $# -eq 0 ]
                then
                        echo "Please supply an ip address or servername"
                else
                        nmap -sV -sC "$1"
        fi
    fi

}


# Options (as of v0.6) :
#  --version             show program's version number and exit
#  -h, --help            show this help message and exit
#  -o, --only            only show processes or threads actually doing I/O
#  -b, --batch           non-interactive mode
#  -n NUM, --iter=NUM    number of iterations before ending [infinite]
#  -d SEC, --delay=SEC   delay between iterations [1 second]
#  -p PID, --pid=PID     processes/threads to monitor [all]
#  -u USER, --user=USER  users to monitor [all]
#  -P, --processes       only show processes, not all threads
#  -a, --accumulated     show accumulated I/O instead of bandwidth
#  -k, --kilobytes       use kilobytes instead of a human friendly unit
#  -t, --time            add a timestamp on each line (implies --batch)
#  -q, --quiet           suppress some lines of header (implies --batch)
#  --no-help             suppress listing of shortcuts
f_iotop() {

    FUNCTION_NAME="iotop";
    REQUIRED_PKG="iotop";
    PACKAGE_NAME="iotop";

    if isPackageInstalled "$REQUIRED_PKG"; then
        unset -f "f_$FUNCTION_NAME";
        alias "$FUNCTION_NAME"="$PACKAGE_NAME --only --processes --delay=2";
        alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME --only --processes --delay=2");
    fi

}
f_iotop


# check if a package is installed


# check directory exists
isDirectoryAvailable() {
        if [ $# -eq 0 ]
                then
                        echo "Please supply a directory name to check its existence"
                else
                        if [ -d "$1" ]
                                then
                                        true
                                else
                                        false
                        fi
       fi
}


# check file exists
isFileAvailable() {
        if [ $# -eq 0 ]
                then
                        echo "Please supply a filename to check its existence"
                else
                        if [ -f "$1" ]
                                then
                                        true
                                else
                                        false
                        fi
       fi
}


# check if string is a number
isNum() {
        if [ $# -eq 0 ]
                then
                        echo "Please supply a string in order to determine if it's a number"
                else
                        if isnum "$1"
                                then
                                       true
                                else
                                       false
                        fi
        fi
}


# to do: add some other common short cut flavour equivelents
#        alias ls='ls --almost-all --color=always'
#        alias lst='ls --almost-all --color=always --human-readable --reverse -t'
#        alias lsl='ls --almost-all --classify --color=always --human-readable --inode -l --time-style=full-iso'
#        alias lslt='ls --almost-all --classify --color=always --human-readable --inode -l --reverse -t --time-style=full-iso'
#
#        list eza options out
#
# invoke ls with personal settings
# ls options :
#   -F, --classify         : append indicator (one of */=>@|) to entries
#   -l                     : use a long listing format
#   -t                     : sort by modification time, newest first
#   --almost-all           : do not list implied . and ..
#   --color[=WHEN]         : colorize the output; WHEN can be 'never', 'auto', or 'always'
#   --human-readable       : with -l, print sizes in human readable format (e.g., 1K 234M 2G)
#   --indicator-style=WORD : append indicator with style WORD to entry names: none, slash (-p), file-type (--file-type), classify (-F)
#   --inode                : print the index number of each file
#   --reverse              : reverse order while sorting
#   --time-style=STYLE     : with -l, show times using style STYLE: full-iso, long-iso, iso, locale, or +FORMAT;
#                             FORMAT is interpreted like in 'date';
#                             if FORMAT is FORMAT1<newline>FORMAT2, then FORMAT1 applies to non-recent files and FORMAT2 to recent files;
#                             if STYLE is prefixed with 'posix-', STYLE takes effect only outside the POSIX locale
f_ls() {

	FUNCTION_NAME="ls";
	REQUIRED_PKG="eza";
	PACKAGE_NAME="eza";

    if [[ "${PERSONAL_ls}" == "true" ]] then

    	if isPackageInstalled "$REQUIRED_PKG"; then
	    	unset -f "f_$FUNCTION_NAME";
		    alias "$FUNCTION_NAME"="$PACKAGE_NAME --all --classify --color=always --color-scale=all --color-scale-mode=gradient --context --extended --flags --git --group --header --icons --inode --links --long --mounts --octal-permissions --time-style=long-iso";
    		alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME --all --classify --color=always --color-scale=all --color-scale-mode=gradient --context --extended --flags --git --group --header --icons --inode --links --long --mounts --octal-permissions --time-style=long-iso");
    	else
	    	alias "$FUNCTION_NAME"="$FUNCTION_NAME $LS_OPTIONS --almost-all --classify --human-readable --inode -l --time-style=long-iso";
		    alias_installed+=("$FUNCTION_NAME"="$FUNCTION_NAME $LS_OPTIONS --almost-all --classify --human-readable --inode -l --time-style=long-iso");
    	fi

    fi

}
f_ls

# to do: incorporate these (x2) into the f_ls block above
# list what node modules are installed on the system
if [[ "${PERSONAL_ls}" == "true" ]]
  then
    alias lsnode='lsl /usr/lib64/node_modules/'
  else
    alias lsnode='lsl --almost-all --color --human-readable --inode -l /usr/lib64/node_modules/'
fi

# list what packages are installed on the system
if [[ "${PERSONAL_ls}" == "true" ]]
  then
    alias lspkgs='lsl /var/log/packages/'
  else
    alias lspkgs='lsl --almost-all --color --human-readable --inode -l /var/log/packages/'
fi

lsgroups() {

	#awk -F: '{printf "%-20s %-10s %-10s %-10s\n", $1, $2, $3, $4}' /etc/group;
        column -t -s ":" -n /etc/group;

}

lsusers() {

	#awk -F: '{printf "%-20s %-10s %-10s %-10s %-40s %-20s %-20s\n", $1, $2, $3, $4, $5, $6, $7}' /etc/passwd;
        column -t -s ":" -n /etc/passwd;

}

f_mv() {

    FUNCTION_NAME="mv";
    REQUIRED_PKG="rsync";
    PACKAGE_NAME="rsync";

    if isPackageInstalled "$REQUIRED_PKG"; then
        unset -f "f_$FUNCTION_NAME";
        # alias "$FUNCTION_NAME"="$PACKAGE_NAME --acls --atimes --compress --crtimes --devices --group --hard-links --links --owner --perms --partial --partial-dir=/tmp/ --preallocate --progress --recursive --remove-source-files --skip-compress=$RSYNC_SKIP_COMPRESS --specials --stats --temp-dir=/tmp --times --xattrs";
        # crtimes seen not to work on this (debian?) version. Unsure if it Debian or the fact its v3.2.3 - as it works on Slackware v3.2.7
        alias "$FUNCTION_NAME"="$PACKAGE_NAME --acls --atimes --compress --devices --group --hard-links --links --owner --perms --partial --partial-dir=.rsync-partial --preallocate --progress --recursive --remove-source-files --skip-compress=$RSYNC_SKIP_COMPRESS --specials --stats --times --xattrs";
        alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME --acls --atimes --compress --devices --group --hard-links --links --owner --perms --partial --partial-dir=.rsync-partial --preallocate --progress --recursive --remove-source-files --skip-compress=$RSYNC_SKIP_COMPRESS --specials --stats --times --xattrs");
    fi

}
f_mv


f_mvDryRun() {

    FUNCTION_NAME="mvDryRun";
    REQUIRED_PKG="rsync";
    PACKAGE_NAME="rsync";

    if isPackageInstalled "$REQUIRED_PKG"; then
	unset -f "f_$FUNCTION_NAME";
        alias "$FUNCTION_NAME"="$PACKAGE_NAME --acls --atimes --compress --devices --group --hard-links --links --list-only --owner --perms --partial --partial-dir=.rsyn-partial --preallocate --progress --recursive --remove-source-files --skip-compress=$RSYNC_SKIP_COMPRESS --specials --stats --temp-dir=.rsync-partial --times --xattrs";
        alias_installed+=("$FUNCTION_NAME"="$PACKAGE_NAME --acls --atimes --compress --devices --group --hard-links --links --list-only --owner --perms --partial --partial-dir=.rsyn-partial --preallocate --progress --recursive --remove-source-files --skip-compress=$RSYNC_SKIP_COMPRESS --specials --stats --temp-dir=.rsync-partial --times --xattrs");
    fi

}
f_mvDryRun


# to do : once cecho is installed, we can (re)introduce this code block
# Initialise a new git project
#git_init() {
#    if [ -z "$1" ]; then
#        cecho -error "ERROR: " -info "You did not specify a directory name for " -variable "${FUNCNAME[0]}" -info " No action has been taken.\n"
#    else
#        mkdir "$1"
#        builtin cd "$1" || exit
#        pwd
#        git init
#        touch readme.md .gitignore LICENSE
#        echo "# $(basename "$PWD")" >>readme.md
#    fi
#}


# add f_ps that will use procs --color=always --sortd cpu --theme=auto --watch if procs is installed
#


# to do : once cecho is installed, we can (re)introduce this code block
# Make a new directory and cd into it.
#mkcd() {
#    if [ -z "$1" ]; then
#        cecho -error "ERROR: " -info "You did not specify a directory name for " -variable "${FUNCNAME[0]}" -info " to create. No action has been taken.\n"
#    else
#        NAME=$1
#        mkdir -p "$NAME"
#        cd "$NAME" || exit
#    fi


#to do: should really move this in to .bash_aliases as it is only a function to setup an alias conditionally
# run neofetch to show local system details
if command -v curl >/dev/null 2>&1; then
    if command -v bash >/dev/null 2>&1; then
        neofetch() {
            curl -s curl -sL https://raw.githubusercontent.com/dylanaraps/neofetch/master/neofetch | bash
        }
    fi
fi


# ps with grep
psg() {
    # shellcheck disable=SC2009
    ps auxf | grep "$1"
}


# run a speedtest to test your internet connection
if command -v curl >/dev/null 2>&1; then
    if command -v python >/dev/null 2>&1; then
        run_speedtest() {
            curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
        }
    fi
fi


# show rickroll :)
if command -v curl >/dev/null 2>&1; then
    if command -v bash >/dev/null 2>&1; then
        run_rickroll() {
            curl -sL https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash
        }
    fi
fi

# show Forrest Gump style animation in the terminal
if command -v curl >/dev/null 2>&1; then
    show_forrest() {
        curl ascii.live/forrest
    }
fi

# show Star Wars in the terminal
if command -v curl >/dev/null 2>&1; then
    show_starwars() {
        curl https://asciitv.fr
    }
fi


# to do : once cecho is installed, we can (re)introduce this code block
# show top cpu consumers
#show_top_cpu_consumers() {
#    processes=$1
#    if [ $# -lt 1 ]; then
#        processes=10 # top 10 cpu processes
#        cecho -warning "WARNING: " -info "You did not specify how many processes for " -variable "${FUNCNAME[0]}" -info " to show, so a default of " -variable $processes -info " has been applied.\n"
#    fi
#
#    ps aux | sort -n +2 | tail -"$processes"
#}


# to do : once cecho is installed, we can (re)introduce this code block
# show top memory consumers
#show_top_memory_consumers() {
#    processes=$1
#    if [ $# -lt 1 ]; then
#        processes=10 # top 10 cpu processes
#        cecho -warning "WARNING: " -info "You did not specify how many processes for " -variable "${FUNCNAME[0]}" -info " to show, so a default of -variable " $processes -info " has been applied.\n"
#    fi
#
#    ps aux | sort -n +3 | tail -"$processes"
#}


sysinfo() {

    infoDistro;
    echo;
    infoMemory; 
    echo;
    infoCpuUtilisation;
    echo;
    infoMemoryProcesses;
    echo;
    echo "External IP : "; infoExternalIp
    echo;

}


trash() {

        if [ $# -ne 1 ]
                then
                        echo "Please supply a (single) directory/path"
                else
                        mv "$@" $HOME/.local/share/trash 
                        echo "Your files are in the trash ($HOME/.local/share/trash) waiting to be emptied (amd reclaim disk space)"

        fi

}


# cd 'up' n levels
up () {
        COUNTER=$1
        while [[ $COUNTER -gt 0 ]]
                do
                UP="${UP}../"
                COUNTER=$(( COUNTER -1 ))
        done
        echo "cd $UP"
        cd "$UP" || exit
        UP=''
}


# to do : once cecho is installed, we can (re)introduce this code block
# Updates
#update () {
#    if [[ $(DISTRO) == *"Ubuntu"* ]]; then
#        cecho -info "INFO: Updating available software\n----"
#        sudo apt-get update
#        cecho -info "\nINFO: Upgrading software\n----"
#        sudo apt-get -y upgrade
#        cecho -info "\nINFO: Removing obsolete dependency software\n----"
#        sudo apt-get -y autoremove
#        cecho -info "\nINFO: Removing software in local cache\n----"
#        sudo apt-get clean
#        cecho -success "SUCCESS: Update/Upgrade done"
#    elif [[ $(DISTRO) == *"Fedora"* ]]; then
#        cecho -info "INFO: Updating available software\n----"
#        sudo dnf upgrade
#        cecho -info "\nINFO: Removing obsolete dependency software\n----"
#        sudo dnf autoremove
#        cecho -info "\nINFO: Removing software in local cache\n----"
#        sudo dnf clean all
#       cecho -success "SUCCESS: Update/Upgrade done"
#    elif [[ $(DISTRO) == *"Arch"* ]]; then
#        cecho -info "INFO: Updating available software\n----"
#        sudo pacman -Syy
#        cecho -info "\nINFO: Upgrading software\n----"
#        sudo pacman -Syu
#        cecho -info "\nINFO: Removing obsolete dependency software\n----"
#        pacman -Qtdq | pacman -Rns -
#        cecho -success "SUCCESS: Update/Upgrade done"
#    elif [[ $(IS_MAC) == "true"* ]]; then
#        cecho -info "INFO: Upgrading software\n----"
#        [[ $(command -v brew) ]] && brew upgrade
#    else
#        cecho -error "ERROR: " -variable "$DISTRO" -info " is not handled for automatic update/upgrade. Please update/upgrade manually"
#    fi
#}

# backwards compatbility
alias animated_gif='get_animated_gif'
alias crpto='get_crypto'
alias news_search='get_news'
alias runforrest='show_run_forrest'
alias starwars='show_starwars'
alias weather='get_weather'
alias topcpu='show_top_cpu_consumers'
alias topmem='show_top_memory_consumers'


echo "The following aliases were installed:"

for element in "${alias_installed[@]}"
do
    echo "$element"
done

echo "The following functions are made available:"

for element in "${function_installed[@]}"
do
    echo "$element"
done


echo "**** $HOME/.bash_functions **** ends ****"
