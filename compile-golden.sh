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

info "Kernel source path: $KERNELSOURCE"
info "Working directory: $WORKINGDIR"
info "resulting zImage and zImage-dtb stored at: $WORKINGOUTDIR"

setbuildjobs

info "Moving to kernel source"
cd $KERNELSOURCE

info "Import toolchain environment setup"
info "Toolchain: $TOOLCHAIN"
source  $SAUCE/build/build-$TOOLCHAIN.env

info "Create a buid directory, known as KERNEL_OUT directory"
# then always use "O=$SAUCE/tuna" in kernel compilation

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
make -j$JOBS O=$WORKINGDIR

if [ -f $WORKINGDIR/arch/arm/boot/zImage ]; then

	if [[ -d "$WORKINGOUTDIR" ]]; then
		info "$WORKINGOUTDIR exist already! Removing directory..."
		rm -rf $WORKINGOUTDIR
		info "Re-creating directory..."
		mkdir -p $WORKINGOUTDIR
	fi

	info "Copying the resulting zImage and modules to: $WORKINGOUTDIR"
	info "Creating directory..."
	mkdir -p $WORKINGOUTDIR
	mkdir -p $WORKINGOUTDIR/modules/system/lib/modules
	cp $WORKINGDIR/arch/arm/boot/zImage $WORKINGOUTDIR/
	find $WORKINGDIR/ -type f -name *.ko -exec cp {} $WORKINGOUTDIR/modules/system/lib/modules/ \;
	cp $WORKINGDIR/.config $WORKINGOUTDIR/

	info "Properly stripping the kernel modules for smaller size (implified as stm command inside build.env)..."
	cd $WORKINGOUTDIR/modules/system/lib/modules
	stm

	if [ -n "$ANYKERNEL_DEVICE" ]; then
		info "Generating AnyKernel"
		cd $SAUCE/AnyKernel2/$ANYKERNEL_DEVICE
		. $ANYKERNEL_SCRIPT
		info " ****** Find your AnyKernel at $SAUCE/AnyKernel2/$ANYKERNEL_DEVICE ******"
	fi

	info "####################"
	info "#       Done!      #"
	info "####################"

else
	warn "####################"
	warn "#      FAILED!     #"
	warn "####################"
fi

cd $SAUCE
