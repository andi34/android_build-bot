#!/bin/bash

BRANCH=cm-14.1
STORAGE=~/android2/roms/lineage
VER=7.1.2
ROM="lineage-14.1"
PATCHROM=y
STABLEKERNEL=n
PRIVATEKERNEL=n
LUNCHROM=lineage
LUNCHTYPE=userdebug
JAVAVERTARGET=8
CLEAN_TARGETS=clobber
BUILD_TARGETS="target-files-package"
OTANAME=$ROM
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
