#!/bin/bash
dir=${PWD}
parentdir="$(dirname "$dir")"

SAUCE=$parentdir
KERNELSOURCE=$parentdir/kernel/oneplus/msm8974
TOOLCHAIN="gcc4.9"
DEFCONFIGNAME=bacon_defconfig

WORKINGDIR=$SAUCE/out/$DEFCONFIGNAME
WORKINGOUTDIR=$SAUCE/AnyKernel2/bacon/bacon_defconfig-bin

# AnyKernel2
ANYKERNEL_DEVICE=bacon
ANYKERNEL_SCRIPT=make_anykernel.sh

. `dirname $0`/compile-bacon.sh
