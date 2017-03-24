#!/bin/bash

BRANCH=android-6.0
STORAGE=~/android/roms/omnirom
VER=6.0.1
ROM="omni-"
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=omni
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
UPLOADCROWDIN=n

if [[ ! -z $1 ]]; then
	ONEDEVICEONLY=y
	PRODUCT[0]=$1
	echo "Compiling for ${PRODUCT[$VAL]} only"
else
	echo "Compiling all supported devices"
	ONEDEVICEONLY=n
fi

. `dirname $0`/bot.sh
