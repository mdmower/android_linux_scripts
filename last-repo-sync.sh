#!/bin/bash

CRST=$(tput sgr0)
RED=$(tput setaf 1)
YLW=$(tput setaf 3)

if [ ! -d "$ANDROID_BUILD_TOP" ]; then
	if [ ! -f "./.repo/.repopickle_fetchtimes" ]; then
		echo "${RED}Error:${CRST} either initialize your android environment or run this"
		echo "       script from the top of your android tree."
		exit
	else
		echo "${YLW}Last repo sync:${CRST} $(date -d "1970-01-01 + $(stat -c %Z .repo/.repopickle_fetchtimes) secs" -u +"%e %b %Y, %T %Z")"
	fi
else
	echo "${YLW}Last repo sync:${CRST} $(date -d "1970-01-01 + $(stat -c %Z $ANDROID_BUILD_TOP/.repo/.repopickle_fetchtimes) secs" -u +"%e %b %Y,  %T %Z")"
fi
