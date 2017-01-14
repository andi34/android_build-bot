#!/bin/bash

BRANCH=aosp-6.0
STORAGE=~/android/roms/aosp
VER=6.0.1
ROM=ua
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=ua
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="otapackage"
UPLOADCROWDIN=n

. `dirname $0`/bot.sh
