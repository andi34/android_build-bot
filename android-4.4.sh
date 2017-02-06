#!/bin/bash

BRANCH=android-4.4
STORAGE=~/android/roms/omnirom
VER=4.4.4
ROM=omni-
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=omni
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
UPLOADCROWDIN=n

. `dirname $0`/bot.sh
