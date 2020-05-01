#!/bin/bash
dir=${PWD}
parentdir="$(dirname "$dir")"

SAUCE=$parentdir
PVRSAUCE=$SAUCE/pvr-source/ddk-1.14/eurasiacon
NEWDDK="y"
KERNELSOURCE=$SAUCE/kernel/ti/omap4
TOOLCHAIN="gcc4.8"
DEFCONFIGNAME=espresso_defconfig

WORKINGDIR=$SAUCE/out/$DEFCONFIGNAME
WORKINGOUTDIR=$SAUCE/AnyKernel2/espresso/espresso_defconfig-bin

# AnyKernel2
ANYKERNEL_DEVICE=espresso
ANYKERNEL_SCRIPT=make_anykernel.sh

. `dirname $0`/compile-omap4.sh
