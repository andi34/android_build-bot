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

#-------------------ROMS To Be Built------------------#
# Instructions and examples below:

PRODUCT[0]="p3110"                        # phone model name (product folder name)
LUNCHCMD[0]="p3110"                        # lunch command used for ROM

PRODUCT[1]="p3100"
LUNCHCMD[1]="p3100"

PRODUCT[2]="p5110"
LUNCHCMD[2]="p5110"

PRODUCT[3]="p5100"
LUNCHCMD[3]="p5100"

#---------------------Build Settings------------------#

# select "y" or "n"... Or fill in the blanks...


# use ccache
CCACHE=y

# what dir for ccache?
CCSTORAGE=/ssd1/ccache

# different out path
DIFFERENTOUT=y
# new path for out
OUTPATH=/ssd2/out
SECONDOUTPATH=/ssd2/out/cm-12.1

# Please fill in below the folder they should be moved to.
# The "//" means root. if you are moving to an external HDD you should start with //media/your PC username/name of the storage device An example is below.
# If you are using an external storage device as seen in the example below, be sure to mount it via your file manager (open the drive in a file manager window) or thought the command prompt before you build, or the script will not find your drive.
# If the storage location is on the same drive as your build folder, use a "~/" to begin. It should look like this usually: ~/your storage folder... assuming your storage folder is in your "home" directory.


# Your build source code directory path. In the example below the build source code directory path is in the "home" folder. If your source code directory is on an external HDD it should look like: //media/your PC username/the name of your storage device/path/to/your/source/code/folder
SAUCE=~/android/cm-12.1

# Sync repositories before build
SYNC=n

# run mka installclean first (quick clean build)
QCLEAN=y

# Run make clean first (Slow clean build. Will delete entire contents of out folder...)
CLEAN=y

# Run make clobber first (Realy slow clean build. Deletes all the object files AND the intermediate dependency files generated which specify the dependencies of the cpp files.)

CLOBBER=y

# leave alone
DATE=`eval date +%y``eval date +%m``eval date +%d`

#---------------------Build Bot Code-------------------#
# Very much not a good idea to change this unless you know what you are doing....


echo -n "Moving to source directory..."
cd $SAUCE
echo "done!"

if [ $DIFFERENTOUT = "y" ]; then
        echo "change path for out directory"
        export OUT_DIR_COMMON_BASE=$OUTPATH
        echo "done!"
fi

if [ $CCACHE = "y" ]; then
                        export USE_CCACHE=1
                        export CCACHE_DIR=$CCSTORAGE
                        # set ccache due to your disk space,set it at your own risk
                        prebuilts/misc/linux-x86/ccache/ccache -M 100G
                fi

if [ $CLEAN = "y" ]; then
        echo -n "Running make clean..."
        make clean
        echo "done!"
fi

if [ $CLOBBER = "y" ]; then
        echo -n "Running make clobber..."
        make clobber
        echo "done!"
fi

if [ $SYNC = "y" ]; then
        echo -n "Running repo sync..."
        repo sync -j$J
        echo "done!"
        cd $SAUCE/build
        echo "add back bootzip"
        git fetch http://review.cyanogenmod.org/CyanogenMod/android_build refs/changes/78/107678/2 && git cherry-pick FETCH_HEAD
        echo "----------------------------------------"
        echo "Set metadata on bootzip"
        git fetch https://review.slimroms.org/SlimRoms/android_build refs/changes/19/7219/4 && git cherry-pick FETCH_HEAD
        echo "----------------------------------------"
        cd $SAUCE
fi


for VAL in "${!PRODUCT[@]}"
do

echo -n "Starting build..."
. build/envsetup.sh
croot
lunch cm_${LUNCHCMD[$VAL]}-userdebug

# get time of startup
res1=$(date +%s.%N)

# start compilation
make bootimage -j8 && make bootzip -j8

echo "done!"

# finished? get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"

done

echo "All done!"
