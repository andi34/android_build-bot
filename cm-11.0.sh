#!/bin/bash

BRANCH=cm-11.0
STORAGE=~/android/roms/lineage
VER=4.4.4
ROM=lineage-11
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=cm
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
UPLOADCROWDIN=n

. `dirname $0`/bot.sh
