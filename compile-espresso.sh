#!/bin/bash

readonly red=$(tput setaf 1) #  red
readonly grn=$(tput setaf 2) #  green
readonly ylw=$(tput setaf 3) #  yellow
readonly blu=$(tput setaf 4) #  blue
readonly cya=$(tput setaf 6) #  cyan
readonly txtbld=$(tput bold) # Bold
readonly bldred=$txtbld$red  #  red
readonly bldgrn=$txtbld$grn  #  green
readonly bldylw=$txtbld$ylw  #  yellow
readonly bldblu=$txtbld$blu  #  blue
readonly bldcya=$txtbld$cya  #  cyan
readonly txtrst=$(tput sgr0) # Reset

err() {
	echo "$txtrst${red}$*$txtrst" >&2
}

warn() {
	echo "$txtrst${ylw}$*$txtrst" >&2
}

info() {
	echo "$txtrst${grn}$*$txtrst"
}

info "Kernel source path: $KERNELSOURCE"
info "PVR Source path: $PVRSAUCE"
info "Working directory: $WORKINGDIR"
info "resulting zImage and modules stored at: $WORKINGOUTDIR"

info "Moving to kernel source"
cd $KERNELSOURCE

info "Import toolchain environment setup"
source  $SAUCE/build-gcc4.8.env

info "Create a buid directory, known as KERNEL_OUT directory"
# then always use "O=$SAUCE/espresso" in kernel compilation

info "create working directory"
mkdir -p $WORKINGDIR

warn "Make sure the kernel source clean on first compilation"
make O=$WORKINGDIR mrproper

warn "Rebuild the kernel after a change, maybe we want to reset the compilation counter"
echo 0 > $WORKINGDIR/.version

info "Import kernel config file: $DEFCONFIGNAME"
make O=$WORKINGDIR $DEFCONFIGNAME
info "Change kernel configuration if needed using:"
info "  make O=$WORKINGDIR menuconfig "

info "lets build the kernel"
make -j8 O=$WORKINGDIR

info "Copy the resulting zImage and modules to different localtion"
info "creating directory..."
mkdir -p $WORKINGOUTDIR
mkdir -p $WORKINGOUTDIR/modules
cp $WORKINGDIR/arch/arm/boot/zImage $WORKINGOUTDIR/
find $WORKINGDIR/ -type f -name *.ko -exec cp {} $WORKINGOUTDIR/modules/ \;

info "files moved"

info "Point KERNELDIR to KERNEL_OUT directory"
export KERNELDIR=$WORKINGDIR

warn "Make sure the PVR source clean"
make clean -C $PVRSAUCE/build/linux2/omap4430_android

info "Build the PVR module"
make -j8 -C $PVRSAUCE/build/linux2/omap4430_android TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=540 PLATFORM_VERSION=4.1

info "Copy the resulting PVR module to different localtion"
mv $PVRSAUCE/binary2_540_120_omap4430_android_release/target/pvrsrvkm_sgx540_120.ko $WORKINGOUTDIR/modules/

warn "Don't leave any module objects in PVR source"
make clean -C $PVRSAUCE/build/linux2/omap4430_android

info "Properly strip the kernel modules for smaller size, implified as stm command inside build.env"
cd $WORKINGOUTDIR//modules
stm

info "Done!"
