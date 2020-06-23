#!/bin/bash

BRANCH=android-6.0
STORAGE=~/android2/roms/omnirom
VER=6.0.1
ROM="omni-"
PATCHROM=y
STABLEKERNEL=n
PRIVATEKERNEL=n
LUNCHROM=omni
LUNCHTYPE=user
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="target-files-package"
OTANAME=omni
OTA_TYPE="full"
SAUCE=~/android/$BRANCH

if [[ ! -z $1 ]]; then
	ONEDEVICEONLY=y
	PRODUCT[0]=$1
	echo "Compiling for ${PRODUCT[$VAL]} only"
else
	echo "Compiling all supported devices"
	ONEDEVICEONLY=n
fi

. `dirname $0`/bot.sh
