#!/bin/bash

command_exists () {
    type "$1" &> /dev/null
}

strip() {
    cp $@ out.img
    unpackbootimg -i out.img > image_info.txt
    BIT=`grep "Android magic found at:" image_info.txt | cut -d ':' -f 2 | cut -c 2-`

    if [ $BIT -gt 0 ]; then
        dd bs=$BIT skip=1 if=out.img of=unsigned.img
    fi
}

extract() {
    mkdir -p ramdisk
    cd ramdisk
    gunzip -c ../out.img-ramdisk.gz | cpio -iud
    cd ..
}

cleanup() {
    mv out.img-zImage zImage
    mv out.img-ramdisk.gz ramdisk.gz
    rm out.img out.img-*
}

if ! command_exists unpackbootimg; then
    echo "unpackbootimg not found"
    exit
fi

if [ ! -z "$@" ] && [ -f $@ ]; then
    strip $@
    extract
    cleanup
else
    echo "No valid image specified"
fi

