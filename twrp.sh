#!/bin/bash

#
# NOTE: NEVER rename a *.tar.md5! Convert the recovery.img again if you want to rename the file!
#
# Jul 2014 Android-Andi @ XDA
# Thanks to ketut.kumajaya @ XDA
#

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

#---------------------General Settings------------------#

# select "y" or "n"... Or fill in the blanks... some examples placed in allready.

# recoveryname
RECNAME1="TWRP"

# recovery version number
export TW_DEVICE_VERSION=0
RECVER="3.2.0-$TW_DEVICE_VERSION"

# path to move the *.tar.md5 
#(*.img and *.zip will also get moved if MOVE=y)
STORAGE=~/android2/roms/recovery

# Place your pre-flashable-zip in this path. Nameing of the zip: DEVICENAME1-RECNAME1.zip
ZIPBASE=~/android2/roms/recovery_base

# Your build source code directory path.
# If your source code directory is on an external HDD it should look like: 
# //media/your PC username/the name of your storage device/path/to/your/source/code/folder
if [ "${DEVICENAME1[$VAL]}" = "golden" ]; then
SAUCE=~/android/android-6.0
else
SAUCE=~/android/android-7.1
fi


#---------------------Convert & Move Code----------------#
# Very much not a good idea to change this unless you know what you are doing....

setjdk() {
	if [ "${DEVICENAME1[$VAL]}" = "golden" ]; then
		echo "Setting default jdk to 1.7"
		echo 2 | sudo /usr/bin/update-alternatives --config java > /dev/null
		echo 2 | sudo /usr/bin/update-alternatives --config javac > /dev/null
		echo 2 | sudo /usr/bin/update-alternatives --config javap > /dev/null
	else
		echo "Setting default jdk to 1.8"
		echo 3 | sudo /usr/bin/update-alternatives --config java > /dev/null
		echo 3 | sudo /usr/bin/update-alternatives --config javac > /dev/null
		echo 3 | sudo /usr/bin/update-alternatives --config javap > /dev/null
	fi
}

sourcesync() {
	info "Running repo sync..."
	cd $SAUCE
	if [ -f "$SAUCE/.repo/local_manifests/roomservice.xml" ]; then
		info "Removing roomservice.xml ..."
		rm -rf $SAUCE/.repo/local_manifests/roomservice.xml
	fi
	repo sync -d -c -q --force-sync --jobs=8 --no-tags
	info "done!"
}

startcompile() {
	setjdk
	cd $SAUCE

	if [[ -d "$SAUCE/bootable/recovery" ]]; then
		cd $SAUCE/bootable/recovery

		# we need a fixed TWRP source for STE devices (fix blank screen on boot)
		if [ "${DEVICENAME1[$VAL]}" = "golden" ]; then
			if git config remote.private.url > /dev/null; then
				echo "Private remote exist already"
			else
				echo "adding Private remote"
				git remote add private https://github.com/andi34/Team-Win-Recovery-Project.git
			fi
			git fetch private
			git checkout private/android-7.1-ste
		else
		# always use latest TWRP Source
			if git config remote.omnirom.url > /dev/null; then
				echo "omnirom remote exist already"
			else
				echo "adding omnirom remote"
				git remote add omnirom https://github.com/omnirom/android_bootable_recovery.git
			fi
			git fetch omnirom
			git checkout omnirom/android-8.0
		fi
		cd $SAUCE
	fi

	. build/envsetup.sh
	make clobber
	for VAL in "${!DEVICENAME1[@]}"
	do
	cd $SAUCE

	breakfast ${DEVICENAME1[$VAL]}

	make -j8 recoveryimage

	mkdir -p $STORAGE/${DEVICENAME1[$VAL]}

	if [[ "${DEVICENAME1[$VAL]}" = "espressocommon" || "${DEVICENAME1[$VAL]}" = "p3100" || "${DEVICENAME1[$VAL]}" = "p3110" || "${DEVICENAME1[$VAL]}" = "p3113" || "${DEVICENAME1[$VAL]}" = "p5100" || "${DEVICENAME1[$VAL]}" = "p5110" || "${DEVICENAME1[$VAL]}" = "p5113" || "${DEVICENAME1[$VAL]}" = "golden" ]]; then
		samsungdevice
	fi
	moveimage
	finish
	done
}

samsungdevice() {
	info "Moving to out directory ( $OUT ) ..."
	cd $OUT

	info "Converting recovery.img to a odinflashable *.tar.md5 ..."
	tar -H ustar -c recovery.img > ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar"
	md5sum -t ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar" >> ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar"
	mv ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar" ${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".tar.md5"

	info "Moveing odin flashable *.tar.md5..."
	mv *".tar.md5" $STORAGE/${DEVICENAME1[$VAL]}/

	info "Makeing flashable zip..."
	cp $ZIPBASE/${DEVICENAME1[$VAL]}"-"$RECNAME1".zip" $STORAGE/${DEVICENAME1[$VAL]}/${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".zip"
	zip -g $STORAGE/${DEVICENAME1[$VAL]}/${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".zip" "recovery.img"

	info "Moving back to source directory..."
	cd $SAUCE
}

moveimage() {
	info "Moving to out directory ( $OUT ) ..."
	cd $OUT

	info "Moveing recovery.img..."
	cp "recovery.img" $STORAGE/${DEVICENAME1[$VAL]}/${DEVICENAME2[$VAL]}"_"$RECNAME1"_"$RECVER".img"

	info "Moving back to source directory..."
	cd $SAUCE
}

finish() {
	warn "Make clobber"
	make clobber

	info "Done!"
}

abortcompile() {
	warn "####################"
	warn "#      FAILED!     #"
	warn "####################"
}

#---------------------Device Settings------------------#

read -p "Do you wish to sync source before compile? [y/N] " yn
case $yn in
    [Yy]* )
         SYNC=y
         echo "Syncing source...";;
    [Nn]* )
         SYNC=n
         echo "Not syncing source...";;
    * ) echo "Please answer y or n.";;
esac

if [ "$SYNC" = "y" ]; then
        sourcesync

	if [[ -d "$SAUCE/kernel/ti/omap4" ]]; then
		cd $SAUCE/kernel/ti/omap4
		if git config remote.unlegacy.url > /dev/null; then
			echo "Unlegacy remote exist already"
		else
			echo "adding Unlegacy remote"
			git remote add unlegacy https://github.com/Unlegacy-Android/android_kernel_ti_omap4.git
		fi
		git fetch unlegacy
		git checkout unlegacy/3.0/common
		if [[ "${DEVICENAME1[$VAL]}" = "p3100" || "${DEVICENAME1[$VAL]}" = "p3110" || "${DEVICENAME1[$VAL]}" = "p3113" || "${DEVICENAME1[$VAL]}" = "p5100" || "${DEVICENAME1[$VAL]}" = "p5110" || "${DEVICENAME1[$VAL]}" = "p5113" ]]; then
			git am --whitespace=nowarn $SAUCE/pull/kernel/ti/omap4/0001-NEVER-MERGE-Introduce-an-option-to-force-a-Tab2-vari.patch
		fi
		cd $SAUCE
	fi
fi

if [[ ! -z $1 ]]; then
    if [ "$1" = "golden" ]; then
        DEVICENAME1[0]=golden
        DEVICENAME2[0]="GT-I8190"
        echo "Compiling for ${DEVICENAME1[$VAL]} only"
        startcompile
    elif [[ ! -z $2 ]]; then
        DEVICENAME1[0]=$1
        DEVICENAME2[0]=$2
        echo "Compiling for ${DEVICENAME1[$VAL]} only"
        startcompile
    else
        echo "${DEVICENAME2[$VAL]} not set!"
        abortcompile
    fi
else
    # device name in your "out" folder
    DEVICENAME1[0]="espressocommon"
    DEVICENAME1[1]="maguro"
    DEVICENAME1[2]="toro"
    DEVICENAME1[3]="toroplus"

    # 2nd device name to rename the *.tar.md5 and *.zip the right way
    # the odin-flashable tar.md5 will be name like this: DEVICENAME2_RECNAME1_RECVER.tar
    DEVICENAME2[0]="espresso-common"
    DEVICENAME2[1]="maguro"
    DEVICENAME2[2]="toro"
    DEVICENAME2[3]="toroplus"

    startcompile
fi

# always switch back to omni source
if [[ -d "$SAUCE/bootable/recovery" ]]; then
	cd $SAUCE/bootable/recovery
	if git config remote.omnirom.url > /dev/null; then
		echo "omnirom remote exist already"
	else
		echo "adding omnirom remote"
		git remote add omnirom https://github.com/omnirom/android_bootable_recovery.git
	fi

	if [ "${DEVICENAME1[$VAL]}" = "golden" ]; then
		if git config remote.omnisecurity.url > /dev/null; then
			echo "omnisecurity remote exist already"
		else
			echo "adding omnisecurity remote"
			git remote add omnisecurity https://github.com/omni-security/android_bootable_recovery.git
		fi
		git fetch omnisecurity
		git checkout omnisecurity/android-6.0
	else
		git fetch omnirom
		git checkout omnirom/android-7.1
	fi
	cd $SAUCE
fi
