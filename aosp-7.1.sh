#!/bin/bash

BRANCH=aosp-7.1
STORAGE=~/android/roms/aosp
VER=7.1.2
ROM=ua
TAB2CHANGES=y
STABLEKERNEL=n
PRIVATEKERNEL=y
LUNCHROM=ua
LUNCHTYPE=userdebug
JAVAVERTARGET=8
CLEAN_TARGETS=clobber
BUILD_TARGETS="otapackage"

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
