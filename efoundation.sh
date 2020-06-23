#!/bin/bash

BRANCH=efoundation
STORAGE=~/android2/roms/efoundation
VER=7.1.2
ROM="e-"
PATCHROM=y
STABLEKERNEL=n
PRIVATEKERNEL=n
LUNCHROM=lineage
LUNCHTYPE=userdebug
JAVAVERTARGET=8
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
OTANAME=$ROM
OTA_TYPE="full"
SAUCE=~/android2/$BRANCH

if [[ ! -z $1 ]]; then
	ONEDEVICEONLY=y
	PRODUCT[0]=$1
	echo "Compiling for ${PRODUCT[$VAL]} only"
else
	echo "Compiling all supported devices"
	ONEDEVICEONLY=n
fi

. `dirname $0`/bot.sh
