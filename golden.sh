#!/bin/bash
dir=${PWD}
parentdir="$(dirname "$dir")"

SAUCE=$parentdir
KERNELSOURCE=$SAUCE/kernel/samsung/golden
TOOLCHAIN="gcc4.7"
DEFCONFIGNAME=blackhawk_golden_defconfig
KERNEL_MODULES=y
OMAP_DEVICE=n

WORKINGDIR=$SAUCE/out/$DEFCONFIGNAME
WORKINGOUTDIR=$SAUCE/AnyKernel2/golden/blackhawk_golden_defconfig-bin

# AnyKernel2
ANYKERNEL_DEVICE=golden
ANYKERNEL_SCRIPT=make_anykernel.sh

. `dirname $0`/compile.sh
