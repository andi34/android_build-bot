#!/bin/bash

BRANCH=aosp-4.4
STORAGE=~/android/roms/aosp
VER=4.4.4
ROM=aosp
TAB2CHANGES=y
STABLEKERNEL=y
LUNCHROM=aosp
JAVAVERTARGET=7
HOWCLEAN=clobber
BUILD_TARGETS="otapackage"
UPLOADCROWDIN=n

. `dirname $0`/bot.sh
