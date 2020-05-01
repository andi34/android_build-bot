#!/bin/bash
dir=${PWD}
parentdir="$(dirname "$dir")"

SAUCE=$parentdir
KERNELSOURCE=$parentdir/oneplus/msm8974
TOOLCHAIN="gcc4.9"
DEFCONFIGNAME=bacon_defconfig

WORKINGDIR=$SAUCE/out/$DEFCONFIGNAME
WORKINGOUTDIR=$SAUCE/AnyKernel2/bacon/$DEFCONFIGNAME-bin

. `dirname $0`/compile-bacon.sh
