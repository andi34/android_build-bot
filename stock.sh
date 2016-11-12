#!/bin/bash

SAUCE=~/android/kernelcompile
PVRSAUCE=~/android/aosp-6.0/hardware/ti/omap4/pvr-source/eurasiacon
KERNELSOURCE=~/android/kernelcompile/samsung_espresso_kernel
DEFCONFIGNAME=android_espresso10_omap4430_r02_user_defconfig
WORKINGDIR=$SAUCE/espresso-stock
WORKINGOUTDIR=$WORKINGDIR-bin
. `dirname $0`/compile-espresso.sh
