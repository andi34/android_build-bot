#!/bin/bash

SAUCE=~/android2/kernelcompile
PVRSAUCE=~/android2/official/omap4/stable/pvr-source/eurasiacon
KERNELSOURCE=~/android2/official/kernel/android_kernel_ti_omap4
TOOLCHAIN="gcc4.8"
DEFCONFIGNAME=espresso_defconfig
VARIANTDEFCONFIG=p5110_defconfig
WORKINGDIR=$SAUCE/out/$VARIANTDEFCONFIG
WORKINGOUTDIR=$SAUCE/$VARIANTDEFCONFIG-bin
. `dirname $0`/compile-espresso.sh
