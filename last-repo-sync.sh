#!/bin/bash

CRST=$(tput sgr0)
RED=$(tput setaf 1)
YLW=$(tput setaf 3)

if [ -d "$ANDROID_BUILD_TOP" ]; then
	LRSPATH="$ANDROID_BUILD_TOP/.repo/.repopickle_fetchtimes"
elif [ -f ".repo/.repopickle_fetchtimes" ]; then
	LRSPATH=".repo/.repopickle_fetchtimes"
else
	echo "${RED}Error:${CRST} either initialize your android environment or run this"
	echo "script from the top of your android tree."
	exit
fi

LRSLOCAL=$(date -d "$(stat -c %z $LRSPATH)" +"%e %b %Y, %l:%M:%S %p %Z")
LRSUTC=$(date -d "$(stat -c %z $LRSPATH)" -u +"%e %b %Y, %T %Z")
echo "${YLW}Last repo sync:${CRST} $LRSLOCAL / $LRSUTC"
