#!/bin/bash

# BuildBot script for android builds
# Severely modified by:
# daavvis
# Find me on XDA Developers
# Originally written by:
# Shane Faulkner
# http://shanefaulkner.com
# You are free to modify and distribute this code,
# So long as you keep our names and URL in it.
# Lots of thanks go out to TeamBAMF

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

#-------------------ROMS To Be Built------------------#
# Instructions and examples below:

if [ "$ONEDEVICEONLY" = "n" ]; then
if [ "$ROM" = "ua" ]; then
	PRODUCT[0]="espresso"                        # phone model name (product folder name)
	PRODUCT[1]="espresso3g"
	PRODUCT[2]="tuna"

	ROMDATE=$(date +%Y%m%d-%H%M)
	info "Unlegacy Rom Date: $ROMDATE"
else

	PRODUCT[0]="espressowifi"                        # phone model name (product folder name)
	PRODUCT[1]="espresso3g"

if [ "$BRANCH" = "cm-13.0" ]; then
	PRODUCT[2]="maguro"
	PRODUCT[3]="toro"
	PRODUCT[3]="toroplus"
fi

if [ "$BRANCH" = "android-4.4" ]; then
	PRODUCT[2]="tuna"
fi

if [ "$BRANCH" = "android-6.0" ]; then
	PRODUCT[2]="tuna"
fi

if [ "$BRANCH" = "android-7.1" ]; then
	PRODUCT[2]="tuna"
fi

if [ "$BRANCH" = "mm6.0" ]; then
	PRODUCT[2]="tuna"
	PRODUCT[3]="bacon"
fi

if [ "$BRANCH" = "ng7.1" ]; then
	PRODUCT[2]="tuna"
fi

fi
fi

#---------------------Build Settings------------------#

# use ccache
CCACHE=y

# what dir for ccache?
CCSTORAGE=/ssd1/ccache

# new out path
DIFFERENTOUTPATH=y
OUTPATH=/ssd2/out

# should they be moved out of the output folder?
MOVE=y


SAUCE=~/android/$BRANCH

if [ -z "$BUILD_TARGETS" ]; then
	info "BUILD_TARGETS not specified, using otapackage as default..."
	BUILD_TARGETS="otapackage"
fi


#---------------------Build Variables-------------------#
# Very much not a good idea to change this unless you know what you are doing....
prompterr() {
	read -p "Continue? ($2/N) " prompt; [ "$prompt" = "$2" ] || exit 0;
}

# leave alone
getdate() {
	DATE=`eval date +%y``eval date +%m``eval date +%d`
}

starttime() {
	res1=$(date +%s.%N)
}

totaltime() {
	res2=$(date +%s.%N)
	echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"
}

setbuildjobs() {
	# Set build jobs
	JOBS=$(expr 0 + $(grep -c ^processor /proc/cpuinfo))
	info "Set build jobs to $JOBS"
}

javacheck() {
if [ "$JAVAVERTARGET" == "7" ]; then
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
	if [ -f "$SAUCE/.repo/local_manifests/roomservice.xml" ]; then
		info "Removing roomservice.xml ..."
		rm -rf $SAUCE/.repo/local_manifests/roomservice.xml
	fi
	if [ -f "$SAUCE/.repo/local_manifests/slim_manifest.xml" ]; then
		rm -rf $SAUCE/.repo/local_manifests/slim_manifest.xml
	fi
	repo sync -d -c -q --force-sync --jobs=8 --no-tags
	info "done!"
}

unlegacykernel() {
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
		cd $SAUCE
	fi
}

privatekernel() {
	if [[ -d "$SAUCE/kernel/ti/omap4" ]]; then
		cd $SAUCE/kernel/ti/omap4
		if git config remote.private.url > /dev/null; then
			echo "Private remote exist already"
		else
			echo "adding Private remote"
			git remote add private git@gitlab.com:andi34/android_kernel_ti_omap4.git
		fi
		git fetch private
		git checkout private/staging
		cd $SAUCE
	fi
}

applychanges() {
	cd $SAUCE
	. pull/patchrom
}

setup() {
	cd $SAUCE
	. build/envsetup.sh
	croot
	lunch "$LUNCHROM"_${PRODUCT[$VAL]}-"$LUNCHTYPE"
	if [ "$ROM" = "ua" ]; then
		ROMDATE=$(date +%Y%m%d-%H%M)
		info "Unlegacy Rom Date: $ROMDATE"
	fi
}

cleansource() {
	if [ "$BP" = "y" ]; then
		info "Removing build.prop..."
		rm $OUT/system/build.prop
		info "done!"
	fi

	if [ -z "$CLEAN_TARGETS" ]; then
		warn "CLEAN_TARGETS not specified, skipping..."
	else
		info "Running make $CLEAN_TARGETS..."
		make $CLEAN_TARGETS
		info "done!"
	fi
}

movefiles() {
	info "Moving to cloud or storage directory..."
	info "checking for directory, and creating as needed..."
	if [[ ! -d "$STORAGE/$VER/${PRODUCT[$VAL]}" ]]; then
		mkdir -p $STORAGE/$VER/${PRODUCT[$VAL]}
	else
		info "Directory exist already"
	fi
	if [ "$ROM" = "ua" ]; then
	if [ -f $OUT/*".andi.zip" ]; then
		info "Removing ota zip..."
		rm -rf $OUT/*."andi.zip"
	fi
	fi

	info "Moving files if exist..."
	if [ -f $OUT/$ROM*".zip" ]; then
		info "Moving flashable zip..."
		mv $OUT/$ROM*".zip" $STORAGE/$VER/${PRODUCT[$VAL]}/
	fi

	if [ -f $OUT/*".md5sum" ]; then
		info "Moving md5..."
		mv $OUT/*".md5sum" $STORAGE/$VER/${PRODUCT[$VAL]}/
	fi

	if [ -f $OUT/"recovery.img" ]; then
		info "Moving recovery.img..."
		cp -r $OUT/"recovery.img" $STORAGE/$VER/${PRODUCT[$VAL]}/
	fi
}

makeota() {
	ARCHIVE_DIR=$STORAGE/$VER/${PRODUCT[$VAL]}
	DEVICE_TARGET_FILES_DIR=$ARCHIVE_DIR

	export DEVICE_TARGET_FILES_PATH=$DEVICE_TARGET_FILES_DIR/$(date -u +%Y%m%d%H%M).zip

	info "ARCHIVE_DIR: $ARCHIVE_DIR"
	info "DEVICE_TARGET_FILES_DIR: $DEVICE_TARGET_FILES_DIR"
	info "DEVICE_TARGET_FILES_PATH: $DEVICE_TARGET_FILES_PATH"

	if [[ ! -d "$DEVICE_TARGET_FILES_DIR" ]]; then
		mkdir -p $DEVICE_TARGET_FILES_DIR
	fi

	cp $OUT/obj/PACKAGING/target_files_intermediates/*target_files*.zip $DEVICE_TARGET_FILES_PATH
	rm -f $(readlink $DEVICE_TARGET_FILES_DIR/last.zip) 2>/dev/null
	rm -f $DEVICE_TARGET_FILES_DIR/last.zip 2>/dev/null
	rm -f $DEVICE_TARGET_FILES_DIR/last.prop 2>/dev/null
	mv $DEVICE_TARGET_FILES_DIR/latest.zip $DEVICE_TARGET_FILES_DIR/last.zip 2>/dev/null
	mv $DEVICE_TARGET_FILES_DIR/latest.prop $DEVICE_TARGET_FILES_DIR/last.prop 2>/dev/null
	ln -sf $DEVICE_TARGET_FILES_PATH $DEVICE_TARGET_FILES_DIR/latest.zip
	cp -f $OUT/system/build.prop $DEVICE_TARGET_FILES_DIR/latest.prop
	cp -f $OUT/system/build.prop $ARCHIVE_DIR/build.prop

	export OTA_OPTIONS="-v -p $ANDROID_HOST_OUT $OTA_COMMON_OPTIONS"
	export OTA_FULL_OPTIONS="$OTA_OPTIONS $OTA_FULL_EXTRA_OPTIONS"
	export OTA_INC_OPTIONS="$OTA_OPTIONS"
	export OTA_INC_FAILED="false"

	export OUTPUT_FILE_NAME="$OTANAME"_${PRODUCT[$VAL]}-$VER
	export LATEST_DATE=$(date -r $DEVICE_TARGET_FILES_DIR/latest.prop +%Y%m%d%H%M)

	if [ "$VER" = "4.4.4" ]; then
		OTA_COMMON_OPTIONS=""
		OTA_FULL_EXTRA_OPTIONS=""
	else
		OTA_COMMON_OPTIONS="-t $JOBS"
		OTA_FULL_EXTRA_OPTIONS="--block"
	fi

	info "OTA_OPTIONS: $OTA_OPTIONS"
	info "OTA_COMMON_OPTIONS: $OTA_COMMON_OPTIONS"
	info "OTA_FULL_OPTIONS: $OTA_FULL_OPTIONS"
	info "OTA_INC_OPTIONS: $OTA_INC_OPTIONS"
	info "LATEST_DATE: $LATEST_DATE"
	info "OTA_TYPE: $OTA_TYPE"

	export FILE_NAME=$OUTPUT_FILE_NAME-$LATEST_DATE
	info "FILE_NAME: $FILE_NAME"
	./build/tools/releasetools/ota_from_target_files \
	$OTA_FULL_OPTIONS \
	$DEVICE_TARGET_FILES_DIR/latest.zip $ARCHIVE_DIR/$FILE_NAME.zip

	if [ -f $ARCHIVE_DIR/$FILE_NAME.zip ]
	then
		info "generating md5sum..."
		md5sum $ARCHIVE_DIR/$FILE_NAME.zip | cut -d ' ' -f1 > $ARCHIVE_DIR/$FILE_NAME.zip.md5sum
	fi

	info "Trying to generate incremental update..."
	if [ -f $DEVICE_TARGET_FILES_DIR/last.zip ]
	then
		export LAST_DATE=$(date -r $DEVICE_TARGET_FILES_DIR/last.prop +%Y%m%d%H%M)
		export FILE_NAME=$OUTPUT_FILE_NAME-$LAST_DATE-TO-$LATEST_DATE
		info "FILE_NAME: $FILE_NAME"
		./build/tools/releasetools/ota_from_target_files \
		$OTA_INC_OPTIONS \
		--incremental_from $DEVICE_TARGET_FILES_DIR/last.zip \
		$DEVICE_TARGET_FILES_DIR/latest.zip $ARCHIVE_DIR/$FILE_NAME.zip

		if [ -f $ARCHIVE_DIR/$FILE_NAME.zip ]
		then
			export OTA_INC_FAILED="false"
			info "OTA_INC_FAILED: $OTA_INC_FAILED"
			md5sum $ARCHIVE_DIR/$FILE_NAME.zip | cut -d ' ' -f1 > $ARCHIVE_DIR/$FILE_NAME.zip.md5sum
		else
			export OTA_INC_FAILED="true"
			info "OTA_INC_FAILED: $OTA_INC_FAILED"
			err "Incremental failed!"
		fi
	else
		warn "Incremental not possible!"
	fi
}

#---------------------Build Process -------------------#

javacheck
info "Moving to source directory..."
cd $SAUCE

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

        cd $SAUCE
        . build/envsetup.sh
        if [ "$BRANCH" = "cm-11.0" ]; then
        ./vendor/cm/get-prebuilts
        fi
        if [ "$STABLEKERNEL" = "y" ]; then
               unlegacykernel
        fi
        if [ "$PRIVATEKERNEL" = "y" ]; then
               privatekernel
        fi
        if [ "$PATCHROM" = "y" ]; then
               applychanges
        fi
fi

if [ "$CCACHE" = "y" ]; then
	export USE_CCACHE=1
	#  CCACHE_NLEVELS: The environment variable CCACHE_NLEVELS allows you to choose the number of levels of hash in the cache directory. The default is 2. The minimum is 1 and the maximum is 8.
	export CCACHE_NLEVELS=4
	export CCACHE_DIR=$CCSTORAGE
	# set ccache due to your disk space,set it at your own risk
	prebuilts/misc/linux-x86/ccache/ccache -M 100G
fi

if [ "$DIFFERENTOUTPATH" = "y" ]; then
	info "Change path for out directory to $OUTPATH"
	export OUT_DIR_COMMON_BASE=$OUTPATH
	info "done!"
fi

setbuildjobs
setup
cleansource

for VAL in "${!PRODUCT[@]}"
do

info "Starting build..."
setup

# get time of startup
getdate
starttime

# start compilation
make -j$JOBS $BUILD_TARGETS

if [ "$BUILD_TARGETS" = "target-files-package" ]; then
	makeota
else
	movefiles
fi

info "done!"

# finished? get elapsed time
totaltime

done

#warn "running make clobber"
#make clobber

info "All done!"
