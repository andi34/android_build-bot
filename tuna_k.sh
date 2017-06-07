#!/bin/bash

SAUCE=~/android2/kernelcompile
PVRSAUCE=~/android2/official/omap4/stable/pvr-source/eurasiacon
KERNELSOURCE=~/android2/official/kernel/tuna/staging
DEFCONFIGNAME=tuna_kitkat_defconfig
WORKINGDIR=$SAUCE/tuna-kitkat
WORKINGOUTDIR=$WORKINGDIR-bin
. `dirname $0`/compile-tuna.sh
