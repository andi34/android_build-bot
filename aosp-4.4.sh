#!/bin/bash

BRANCH=aosp-4.4
STORAGE=~/android/roms/aosp
VER=4.4.4
ROM=ua
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=ua
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="otapackage"
UPLOADCROWDIN=n

. `dirname $0`/bot.sh
