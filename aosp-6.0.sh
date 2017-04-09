#!/bin/bash

BRANCH=aosp-6.0
STORAGE=~/android/roms/aosp
VER=6.0.1
ROM=ua
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=ua
LUNCHTYPE=userdebug
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="otapackage"

if [[ ! -z $1 ]]; then
	ONEDEVICEONLY=y
	PRODUCT[0]=$1
	echo "Compiling for ${PRODUCT[$VAL]} only"
else
	echo "Compiling all supported devices"
	ONEDEVICEONLY=n
fi

. `dirname $0`/bot.sh
