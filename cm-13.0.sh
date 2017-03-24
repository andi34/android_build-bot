#!/bin/bash

BRANCH=cm-13.0
STORAGE=~/android/roms/lineage
VER=6.0.1
ROM="lineage-"
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=lineage
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
UPLOADCROWDIN=n

if [[ ! -z $1 ]]; then
	ONEDEVICEONLY=y
	PRODUCT[0]=$1
	echo "Compiling for ${PRODUCT[$VAL]} only"
else
	echo "Compiling all supported devices"
	ONEDEVICEONLY=n
fi

. `dirname $0`/bot.sh
