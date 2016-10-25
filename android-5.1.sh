#!/bin/bash

BRANCH=android-5.1
STORAGE=~/android/roms/omnirom
VER=5.1.1
ROM=omni
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=omni
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
UPLOADCROWDIN=n

. `dirname $0`/bot.sh
