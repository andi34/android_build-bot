#!/bin/bash

SAUCE=~/android/kernelcompile
PVRSAUCE=~/android/aosp-6.0/hardware/ti/omap4/pvr-source/eurasiacon
KERNELSOURCE=~/android/official/kernel/stable
DEFCONFIGNAME=espresso_kitkat_defconfig
WORKINGDIR=$SAUCE/espresso-kitkat
WORKINGOUTDIR=$WORKINGDIR-bin
. `dirname $0`/compile-espresso.sh
