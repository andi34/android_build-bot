#!/bin/bash

BRANCH=aosp-6.0
STORAGE=~/android2/roms/aosp
VER=6.0.1
ROM=ua
PATCHROM=y
STABLEKERNEL=n
PRIVATEKERNEL=y
LUNCHROM=ua
LUNCHTYPE=userdebug
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="target-files-package"
OTANAME=$ROM
OTA_TYPE="full"

if [[ ! -z $1 ]]; then
    ONEDEVICEONLY=y
    if [ "$1" = "espressowifi" ]; then
        echo "assuming espresso device, espressowifi does not exist on UA"
        PRODUCT[0]=espresso
    else
        PRODUCT[0]=$1
    fi
    echo "Compiling for ${PRODUCT[$VAL]} only"
else
    echo "Compiling all supported devices"
    ONEDEVICEONLY=n
fi

. `dirname $0`/bot.sh
