#!/bin/bash

BRANCH=mm6.0
STORAGE=~/android/roms/slimroms
VER=6.0.1
ROM=Slim
PATCHROM=y
STABLEKERNEL=n
PRIVATEKERNEL=y
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
