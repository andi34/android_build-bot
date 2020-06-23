#!/bin/bash

BRANCH=cm-11.0
STORAGE=~/android2/roms/lineage
VER=4.4.4
ROM=lineage-11
PATCHROM=y
STABLEKERNEL=n
PRIVATEKERNEL=n
LUNCHROM=lineage
LUNCHTYPE=user
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
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
