#!/bin/bash

SAUCE=~/android2/kernelcompile
KERNELSOURCE=~/android2/kernel_oneplus_msm8974
TOOLCHAIN="gcc4.9"
DEFCONFIGNAME=bacon_defconfig
WORKINGDIR=$SAUCE/bacon-marshmallow
WORKINGOUTDIR=$WORKINGDIR-bin
. `dirname $0`/compile-bacon.sh
