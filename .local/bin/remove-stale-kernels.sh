#!/bin/bash
# Removes stale kernel packages on Ubuntu systems.  Always keeps two kernels:
# the currently-running one and the newest one from the rest.
# Inspired by http://askubuntu.com/questions/401581/bash-one-liner-to-delete-only-old-kernel
kernels=$(dpkg -l linux-image-[0-9].* | awk '/^ii/{print $2}')
to_remove=$(echo "$kernels" | grep -v $(uname -r) | head -n -1)
to_keep=$(comm -3 <(echo "$kernels") <(echo "$to_remove"))
if [ -n "$to_remove" ]; then
  echo "Will remove"
  printf "  %s\n" $to_remove
  echo "Will keep"
  printf "  %s\n" $to_keep
  sudo apt-get remove $to_remove --auto-remove
else
  echo "Nothing to remove.  Installed kernels:"
  printf "  %s\n" $to_keep
fi

