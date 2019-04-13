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

setbuildjobs() {
	# Set build jobs
	JOBS=$(expr 0 + $(grep -c ^processor /proc/cpuinfo))
	info "Set build jobs to $JOBS"
}

read -p "Using new DDK? [y/N] " yn
case $yn in
    [Yy]* )
         NEWDDK=y
         echo "Using new DDK";;
    [Nn]* )
         NEWDDK=n
         echo "Using old DDK";;
    * ) echo "Please answer y or n.";;
esac

if [ -n "$VARIANTDEFCONFIG" ]; then
	WORKINGDIR=$SAUCE/out/$DEFCONFIGNAME
	WORKINGOUTDIR=$SAUCE/$DEFCONFIGNAME-bin
else

	if [ "$DEFCONFIGNAME" = "espresso_kitkat_defconfig" ]; then
		WORKINGDIR=$SAUCE/out/$VARIANTDEFCONFIG-kitkat
		WORKINGOUTDIR=$SAUCE/$VARIANTDEFCONFIG-bin-kitkat
	else
		WORKINGDIR=$SAUCE/out/$VARIANTDEFCONFIG
		WORKINGOUTDIR=$SAUCE/$VARIANTDEFCONFIG-bin
	fi
fi

info "Kernel source path: $KERNELSOURCE"
info "PVR Source path: $PVRSAUCE"
info "Working directory: $WORKINGDIR"
info "resulting zImage and modules stored at: $WORKINGOUTDIR"

setbuildjobs

info "Moving to kernel source"
cd $KERNELSOURCE

info "Import toolchain environment setup"
info "Toolchain: $TOOLCHAIN"
source  $SAUCE/build-$TOOLCHAIN.env

info "Create a buid directory, known as KERNEL_OUT directory"
# then always use "O=$SAUCE/espresso" in kernel compilation

info "create working directory"
mkdir -p $WORKINGDIR

warn "Make sure the kernel source clean on first compilation"
make O=$WORKINGDIR mrproper

warn "Rebuild the kernel after a change, maybe we want to reset the compilation counter"
echo 0 > $WORKINGDIR/.version

if [ -n "$VARIANTDEFCONFIG" ]; then
	info "Import kernel config file: $DEFCONFIGNAME"
	info "Import variant config file: $VARIANTDEFCONFIG"
	make O=$WORKINGDIR VARIANT_DEFCONFIG=$VARIANTDEFCONFIG $DEFCONFIGNAME
	info "Change kernel configuration if needed using:"
	info "  make O=$WORKINGDIR menuconfig "
	VARIANTDEFCONFIG=
else
	info "Import kernel config file: $DEFCONFIGNAME"
	make O=$WORKINGDIR $DEFCONFIGNAME
	info "Change kernel configuration if needed using:"
	info "  make O=$WORKINGDIR menuconfig "
fi

info "lets build the kernel"
make -j$JOBS O=$WORKINGDIR

if [ -f $WORKINGDIR/arch/arm/boot/zImage ]; then
	info "Copying the resulting zImage and modules to: $WORKINGOUTDIR"
	info "Creating directory..."
	mkdir -p $WORKINGOUTDIR
	mkdir -p $WORKINGOUTDIR/modules/system/lib/modules
	cp $WORKINGDIR/arch/arm/boot/zImage $WORKINGOUTDIR/
	find $WORKINGDIR/ -type f -name *.ko -exec cp {} $WORKINGOUTDIR/modules/system/lib/modules/ \;
	cp $WORKINGDIR/.config $WORKINGOUTDIR/

	info "Files moved!"

	info "Pointing KERNELDIR to KERNEL_OUT directory"
	export KERNELDIR=$WORKINGDIR

	warn "Make sure the PVR source clean."
	warn "Running 'make clean'..."

	if [ "$NEWDDK" = "y" ]; then
		make clean -C $PVRSAUCE/build/linux2/omap_android

		info "Building the PVR module..."
		# we now use the default libion, our kernel was updated
		make -j8 -C $PVRSAUCE/build/linux2/omap_android TARGET_DEVICE="blaze_tablet" PLATFORM_RELEASE="4.4" PLATFORM_CODENAME="REL"

		info "Copying the resulting PVR module to: $WORKINGOUTDIR"
		cp -fr $PVRSAUCE/binary2_omap_android_release/target/pvrsrvkm.ko $WORKINGOUTDIR/modules/system/lib/modules/pvrsrvkm_sgx540_120.ko
		mv $PVRSAUCE/binary2_omap_android_release/target/pvrsrvkm.ko $WORKINGOUTDIR/modules/system/lib/modules/
		mv $PVRSAUCE/binary2_omap_android_release/target/omaplfb.ko $WORKINGOUTDIR/modules/system/lib/modules/

		warn "Don't leave any module objects in PVR source!"
		warn "Running 'make clean'..."
		make clean -C $PVRSAUCE/build/linux2/omap_android

	else

		make clean -C $PVRSAUCE/build/linux2/omap4430_android

		info "Building the PVR module..."
		# we now use the default libion, our kernel was updated
		make -j8 -C $PVRSAUCE/build/linux2/omap4430_android TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=540 PLATFORM_VERSION=4.1

		info "Copying the resulting PVR module to: $WORKINGOUTDIR"
		cp -fr $PVRSAUCE/binary2_omap4430_android_release/target/pvrsrvkm.ko $WORKINGOUTDIR/modules/system/lib/modules/pvrsrvkm_sgx540_120.ko
		mv $PVRSAUCE/binary2_omap4430_android_release/target/pvrsrvkm.ko $WORKINGOUTDIR/modules/system/lib/modules/

		warn "Don't leave any module objects in PVR source!"
		warn "Running 'make clean'..."
		make clean -C $PVRSAUCE/build/linux2/omap4430_android
	fi

	info "Properly stripping the kernel modules for smaller size (implified as stm command inside build.env)..."
	cd $WORKINGOUTDIR/modules/system/lib/modules
	stm

	info "####################"
	info "#       Done!      #"
	info "####################"
else
	warn "####################"
	warn "#      FAILED!     #"
	warn "####################"
fi

cd $SAUCE
