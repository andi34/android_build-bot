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

if [ "$ROM" = "ua" ]; then
	PRODUCT[0]="espresso"                        # phone model name (product folder name)
	PRODUCT[1]="espresso3g"
	PRODUCT[2]="tuna"

	ROMDATE=$(date +%Y%m%d-%H%M)
	info "Unlegacy Rom Date: $ROMDATE"
else

	PRODUCT[0]="espressowifi"                        # phone model name (product folder name)
	PRODUCT[1]="espresso3g"

if [ "$BRANCH" = "mm6.0" ]; then
	PRODUCT[2]="tuna"
	PRODUCT[3]="bacon"
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

# Sync repositories before build
SYNC=y

# Run make clean first (Slow clean build. Will delete entire contents of out folder...)
CLEAN=y

# Run make clobber first (Realy slow clean build. Deletes all the object files AND the intermediate dependency files generated which specify the dependencies of the cpp files.)
CLOBBER=y


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
	repo sync -d -f -j8 --force-sync
	info "done!"
}

unlegacykernel() {
	cd $SAUCE/kernel/samsung/$KERNELNAMETAB2
        if git config remote.unlegacy.url > /dev/null; then
          echo "Unlegacy remote exist already"
        else
          echo "adding Unlegacy remote"
	  git remote add unlegacy https://github.com/Unlegacy-Android/android_kernel_samsung_espresso.git
        fi
	git fetch unlegacy
	git checkout unlegacy/staging
	cd $SAUCE

	cd $SAUCE/kernel/samsung/tuna
        if git config remote.unlegacy.url > /dev/null; then
          echo "Unlegacy remote exist already"
        else
          echo "adding Unlegacy remote"
	  git remote add unlegacy https://github.com/Unlegacy-Android/android_kernel_samsung_tuna.git
        fi
	git fetch unlegacy
	git checkout unlegacy/staging
	cd $SAUCE
}

devicechanges() {
	cd $SAUCE
	. pull/tab2
	if [ "$BRANCH" = "lp5.1" ]; then
		. pull/globalmenu
	fi
}

setup() {
	cd $SAUCE
	. build/envsetup.sh
	croot
	lunch "$LUNCHROM"_${PRODUCT[$VAL]}-userdebug
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
		warn "CLEAN_TARGETS not specified, using make clobber as default..."
		CLEAN_TARGETS=clobber
	else
		info "Running make $CLEAN_TARGETS..."
	fi

	make $CLEAN_TARGETS
	info "done!"
}

movefiles() {
	info "Moving to cloud or storage directory..."
	info "checking for directory, and creating as needed..."
	if [[ ! -d "$STORAGE/$VER/${PRODUCT[$VAL]}" ]]; then
		mkdir -p $STORAGE/$VER/${PRODUCT[$VAL]}
	else
		info "Directory exist already"
	fi

	info "Moving files if exist..."
	if [ "$ROM" = "ua" ]; then
		if [ -f $OUT/$ROM*".zip" ]; then
			info "Moving flashable zip..."
			mv $OUT/$ROM*".zip" $STORAGE/$VER/${PRODUCT[$VAL]}/$ROM"_"${PRODUCT[$VAL]}-$VER-$ROMDATE".zip"
		fi
	else
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
	fi
}


#---------------------Build Process -------------------#
javacheck
info "Moving to source directory..."
cd $SAUCE

if [ "$SYNC" = "y" ]; then
        sourcesync

        cd $SAUCE
        . build/envsetup.sh
        if [ "$BRANCH" = "cm-11.0" ]; then
        ./vendor/cm/get-prebuilts
        . pull/asb12017
        . pull/asb22017
        . pull/asb32017
        fi
        if [ "$BRANCH" = "mm6.0" ]; then
        repopick -t asb
        fi
        if [ "$STABLEKERNEL" = "y" ]; then
          if [ "$ROM" = "ua" ]; then
	     KERNELNAMETAB2=espresso
          else
             KERNELNAMETAB2=espresso10
          fi
               unlegacykernel
        fi
        if [ "$TAB2CHANGES" = "y" ]; then
               devicechanges
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

info "done!"

# finished? get elapsed time
totaltime

movefiles

done

#warn "running make clobber"
#make clobber

info "All done!"
