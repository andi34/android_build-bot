#!/bin/bash

SAUCE=~/android2/kernelcompile
KERNELSOURCE=~/android2/android_kernel_samsung_golden
TOOLCHAIN="gcc4.7"
DEFCONFIGNAME=blackhawk_golden_defconfig
WORKINGDIR=$SAUCE/golden-blackhawk
WORKINGOUTDIR=$WORKINGDIR-bin
. `dirname $0`/compile-golden.sh
