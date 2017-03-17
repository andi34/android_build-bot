#!/bin/bash

BRANCH=aosp-7.1
STORAGE=~/android/roms/aosp
VER=7.1.1
ROM=ua
TAB2CHANGES=y
STABLEKERNEL=n
LUNCHROM=ua
JAVAVERTARGET=8
CLEAN_TARGETS=clobber
BUILD_TARGETS="otapackage"
UPLOADCROWDIN=n

. `dirname $0`/bot.sh
