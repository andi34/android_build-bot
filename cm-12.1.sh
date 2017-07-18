#!/bin/bash

BRANCH=cm-12.1
STORAGE=~/android/roms/cm
VER=5.1.1
ROM=cm-12.1
TAB2CHANGES=y
STABLEKERNEL=n
PRIVATEKERNEL=y
LUNCHROM=cm
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
