#!/bin/bash

BRANCH=android-7.1
STORAGE=~/android2/roms/omnirom
VER=7.1.2
ROM="omni-"
PATCHROM=y
STABLEKERNEL=n
PRIVATEKERNEL=y
LUNCHROM=omni
LUNCHTYPE=userdebug
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
