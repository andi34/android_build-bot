#!/bin/bash

BRANCH=mm6.0
STORAGE=~/android2/roms/slimroms
VER=6.0.1
ROM=Slim
PATCHROM=y
STABLEKERNEL=n
PRIVATEKERNEL=y
LUNCHROM=slim
LUNCHTYPE=userdebug
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="target-files-package"
OTANAME=$ROM
OTA_TYPE="full"

if [[ ! -z $1 ]]; then
	ONEDEVICEONLY=y
	PRODUCT[0]=$1
	echo "Compiling for ${PRODUCT[$VAL]} only"
	if [ "$1" = "bacon" ]; then
		OSSCAM=y
		echo "Compiling with OSS camera HAL"
	fi
else
	echo "Compiling all supported devices"
	ONEDEVICEONLY=n
	OSSCAM=n
fi

. `dirname $0`/bot.sh
