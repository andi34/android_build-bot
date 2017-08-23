#!/bin/bash

BRANCH=cm-14.1
STORAGE=~/android2/roms/lineage
VER=7.1.2
ROM="lineage-"
PATCHROM=y
STABLEKERNEL=n
PRIVATEKERNEL=y
LUNCHROM=lineage
LUNCHTYPE=userdebug
JAVAVERTARGET=8
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
