#!/bin/bash

BRANCH=aosp-7.1
STORAGE=~/android/roms/aosp
VER=7.1.2
ROM=ua
TAB2CHANGES=y
STABLEKERNEL=n
LUNCHROM=ua
JAVAVERTARGET=8
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
