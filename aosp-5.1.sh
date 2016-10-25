#!/bin/bash

BRANCH=aosp-5.1
STORAGE=~/android/roms/aosp
VER=5.1.1
ROM=aosp
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=aosp
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="otapackage"
UPLOADCROWDIN=n

. `dirname $0`/bot.sh
