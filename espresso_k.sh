#!/bin/bash
dir=${PWD}
parentdir="$(dirname "$dir")"

SAUCE=$parentdir
PVRSAUCE=$SAUCE/pvr-source/ddk-1.14/eurasiacon
NEWDDK="y"
KERNELSOURCE=$SAUCE/kernel/ti/omap4
TOOLCHAIN="gcc4.8"
DEFCONFIGNAME=espresso_kitkat_defconfig

. `dirname $0`/compile-espresso.sh
