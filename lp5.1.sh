#!/bin/bash

BRANCH=lp5.1
STORAGE=~/android/roms/slimroms
VER=5.1.1
ROM=Slim
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=slim
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
