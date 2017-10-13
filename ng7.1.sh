#!/bin/bash

BRANCH=ng7.1
STORAGE=~/android2/roms/slimroms
VER=7.1.2
ROM=Slim
PATCHROM=y
STABLEKERNEL=n
PRIVATEKERNEL=y
LUNCHROM=slim
LUNCHTYPE=userdebug
JAVAVERTARGET=8
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
OTANAME=$ROM
OTA_TYPE="full"

if [[ ! -z $1 ]]; then
	ONEDEVICEONLY=y
	PRODUCT[0]=$1
	echo "Compiling for ${PRODUCT[$VAL]} only"
else
	echo "Compiling all supported devices"
	ONEDEVICEONLY=n
fi

. `dirname $0`/bot.sh
