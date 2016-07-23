#!/bin/bash

# Permissions: drwxrwxr-x media_rw:media_rw
# SEPolicy: u:object_r:media_rw_data_file:s0

ANDROIDDIRS="\
    Alarms \
    Android \
    DCIM \
    Download \
    Movies \
    Music \
    Notifications \
    Pictures \
    Podcasts \
    Ringtones \
"

for i in $ANDROIDDIRS; do
    echo "Creating $i"
    adb shell "mkdir -p /sdcard/$i";
done
