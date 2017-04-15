#!/bin/bash

BRANCH=android-7.1
STORAGE=~/android/roms/omnirom
VER=7.1.2
ROM="omni-"
TAB2CHANGES=y
STABLEKERNEL=n
LUNCHROM=omni
LUNCHTYPE=eng
JAVAVERTARGET=8
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"

if [[ ! -z $1 ]]; then
	ONEDEVICEONLY=y
	PRODUCT[0]=$1
	echo "Compiling for ${PRODUCT[$VAL]} only"
else
	echo "Compiling all supported devices"
	ONEDEVICEONLY=n
fi

. `dirname $0`/bot.sh
