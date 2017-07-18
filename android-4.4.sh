#!/bin/bash

BRANCH=android-4.4
STORAGE=~/android/roms/omnirom
VER=4.4.4
ROM=omni-
TAB2CHANGES=y
STABLEKERNEL=n
PRIVATEKERNEL=y
LUNCHROM=omni
LUNCHTYPE=userdebug
JAVAVERTARGET=7
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
