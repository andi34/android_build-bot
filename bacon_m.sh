#!/bin/bash

SAUCE=~/android2/kernelcompile
KERNELSOURCE=~/android2/kernel_oneplus_msm8974
TOOLCHAIN="gcc4.9"
DEFCONFIGNAME=bacon_defconfig
WORKINGDIR=$SAUCE/out/$DEFCONFIGNAME
WORKINGOUTDIR=$SAUCE/$DEFCONFIGNAME-bin
. `dirname $0`/compile-bacon.sh
