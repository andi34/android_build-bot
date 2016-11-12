#!/bin/sh
(
export CROSS_COMPILE=~/omap4-aosp/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8/bin/arm-eabi-
cd kernel;
make espresso_defconfig;
make;
cd ..;
cp -f kernel/arch/arm/boot/zImage espresso-boot/zImage
mkboot espresso-boot boot.img
)
