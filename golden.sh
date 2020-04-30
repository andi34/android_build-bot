#!/bin/bash
dir=${PWD}
parentdir="$(dirname "$dir")"

SAUCE=$parentdir
KERNELSOURCE=$SAUCE/kernel/samsung/golden
TOOLCHAIN="gcc4.7"
DEFCONFIGNAME=blackhawk_golden_defconfig

WORKINGDIR=$SAUCE/out/$DEFCONFIGNAME
WORKINGOUTDIR=$SAUCE/$DEFCONFIGNAME-bin

. `dirname $0`/compile-golden.sh
