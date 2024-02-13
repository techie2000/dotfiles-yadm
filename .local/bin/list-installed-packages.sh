#!/bin/sh
if [ x"$1" = x"-v" ]; then
    shift
    dpkg-query -W --showformat '${STATUS} ${PACKAGE} ${VERSION}\n' "$@"|grep ' installed '|cut -d ' ' -f 4-
else
    dpkg-query -W --showformat '${STATUS} ${PACKAGE}\n' "$@"|grep ' installed '|cut -d ' ' -f 4-
fi

