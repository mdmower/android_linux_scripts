#!/bin/bash

LOGVIEWER="subl"

if [ -z "$1" ]; then
    echo "Usage: andlogs.sh basefilename"
    exit 1
fi

BFNAME="$1"
adb logcat > "$BFNAME""_lc.log" &
LCPID=$!
adb shell 'su -c "cat /proc/kmsg"' > "$BFNAME""_kmsg.log" &
KMPID=$!

echo "Logging started..."
echo ""
echo "Press [p] to continue logging and open in $LOGVIEWER"
echo "Press [y] to end logging and open in $LOGVIEWER"
echo "or press any other key to end logging..."
read -n 1 openlogs
echo ""

shopt -s nocasematch
if [[ "$openlogs" == "y" ]]; then
    kill $LCPID
    kill $KMPID
    $LOGVIEWER "$BFNAME""_lc.log" "$BFNAME""_kmsg.log"
elif [[ "$openlogs" == "p" ]]; then
    $LOGVIEWER "$BFNAME""_lc.log" "$BFNAME""_kmsg.log"
    echo "Press any key to end logging..."
    read -n 1 openlogs
    echo ""
    kill $LCPID
    kill $KMPID
else
    kill $LCPID
    kill $KMPID
fi
