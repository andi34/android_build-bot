#!/bin/bash

BRANCH=kk4.4
STORAGE=~/android2/roms/slimroms
VER=4.4.4
ROM=Slim
PATCHROM=y
STABLEKERNEL=n
PRIVATEKERNEL=y
LUNCHROM=slim
LUNCHTYPE=user
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
OTANAME=SlimKat
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
