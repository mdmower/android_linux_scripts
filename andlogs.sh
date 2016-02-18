#!/bin/bash

LOGVIEWER="subl"

if [ -z "$1" ]; then
    echo "Usage: andlogs.sh basefilename"
    exit 1
fi
BFNAME="$1"

if [ "$2" == "radio" ]; then
    RADIO=true
fi

adb wait-for-device
adb logcat > "$BFNAME""_lc.log" &
LOGCAT_PID=$!
if [ "$RADIO" = true ]; then
    adb logcat -b radio > "$BFNAME""_rlc.log" &
    RADIO_PID=$!
fi
adb shell 'su -c "cat /proc/kmsg"' > "$BFNAME""_kmsg.log" &
KMSG_PID=$!

trap "kill $LOGCAT_PID $KMSG_PID $RADIO_PID; exit" SIGINT SIGTERM SIGHUP

echo "Logging started..."
echo ""
echo "Press [p] to continue logging and open in $LOGVIEWER"
echo "Press [y] to end logging and open in $LOGVIEWER"
echo "or press any other key to end logging..."
read -n 1 openlogs
echo ""

shopt -s nocasematch
if [[ "$openlogs" == "y" ]] || [[ "$openlogs" == "p" ]]; then
    $LOGVIEWER "$BFNAME""_lc.log" "$BFNAME""_kmsg.log"
    if [ "$RADIO" = true ]; then
        $LOGVIEWER "$BFNAME""_rlc.log"
    fi
fi
if [[ "$openlogs" == "p" ]]; then
    echo "Press any key to end logging..."
    read -n 1 openlogs
    echo ""
fi

kill $LOGCAT_PID $KMSG_PID
if [ "$RADIO" = true ]; then
    kill $RADIO_PID
fi
