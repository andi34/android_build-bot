#!/bin/bash
dir=${PWD}
parentdir="$(dirname "$dir")"

SAUCE=$parentdir
PVRSAUCE=$SAUCE/pvr-source/ddk-1.14/eurasiacon
NEWDDK="y"
KERNELSOURCE=$SAUCE/kernel/ti/omap4
TOOLCHAIN="gcc4.8"
DEFCONFIGNAME=espresso_kitkat_defconfig
KERNEL_MODULES=y
OMAP_DEVICE=y

WORKINGDIR=$SAUCE/out/$DEFCONFIGNAME
WORKINGOUTDIR=$SAUCE/AnyKernel2/espresso/espresso_kitkat_defconfig-bin

# AnyKernel2
ANYKERNEL_DEVICE=espresso
ANYKERNEL_SCRIPT=make_kk_anykernel.sh

. `dirname $0`/compile.sh
