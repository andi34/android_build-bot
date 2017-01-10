#!/bin/bash

BRANCH=cm-13.0
STORAGE=~/android/roms/lineage
VER=6.0.1
ROM=lineage
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=lineage
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
UPLOADCROWDIN=n

. `dirname $0`/bot.sh
