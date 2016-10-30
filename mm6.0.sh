#!/bin/bash

BRANCH=mm6.0
STORAGE=~/android/roms/slimroms
VER=6.0.1
ROM=Slim
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=slim
JAVAVERTARGET=7
CLEAN_TARGETS=clobber
BUILD_TARGETS="bacon"
UPLOADCROWDIN=y

. `dirname $0`/bot.sh
