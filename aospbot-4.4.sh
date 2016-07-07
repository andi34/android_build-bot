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

PRODUCT[0]="espresso"                        # phone model name (product folder name)
LUNCHCMD[0]="espresso"                        # lunch command used for ROM

PRODUCT[1]="espresso3g"                        # phone model name (product folder name)
LUNCHCMD[1]="espresso3g"                        # lunch command used for ROM

#---------------------Build Settings------------------#

# select "y" or "n"... Or fill in the blanks...


#use ccache
CCACHE=y

#what dir for ccache?
CCSTORAGE=/ssd1/ccache

# different out path
DIFFERENTOUT=y
# new path for out
OUTPATH=/ssd1/out
SECONDOUTPATH=/ssd1/out/aosp-4.4

# should they be moved out of the output folder?
# like a dropbox or other cloud storage folder?
# or any other folder you want?
# also required for FTP upload!!

MOVE=y

# Please fill in below the folder they should be moved to.
# The "//" means root. if you are moving to an external HDD you should start with //media/your PC username/name of the storage device An example is below.
# If you are using an external storage device as seen in the example below, be sure to mount it via your file manager (open the drive in a file manager window) or thought the command prompt before you build, or the script will not find your drive.
# If the storage location is on the same drive as your build folder, use a "~/" to begin. It should look like this usually: ~/your storage folder... assuming your storage folder is in your "home" directory.

STORAGE=~/android/roms/aosp

# Do you want to make a folder for the version of android you are building?

AVF=n

# What version of android? (no".")(you only need to fill this out if you answered "y" to the question above)

VER=4.4

# The first few letters of your ROM name... this is needed to move the completed zip to your storage folder.

ROM=aosp

# Your build source code directory path. In the example below the build source code directory path is in the "home" folder. If your source code directory is on an external HDD it should look like: //media/your PC username/the name of your storage device/path/to/your/source/code/folder
SAUCE=~/android/aosp-4.4

# REMOVE BUILD PROP (recomended for every build, otherwise the date of the build may not be changed, as well as other variables)

BP=y

# Number for the -j parameter (choose a smaller number for slower internet conection... default is usually 4... this only controls how many threads are running during repo sync)

J=16

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
fi

for VAL in "${!PRODUCT[@]}"
do

echo -n "Starting build..."
. build/envsetup.sh
croot
lunch aosp_${LUNCHCMD[$VAL]}-userdebug


                if [ $BP = "y" ]; then
                echo "Removing build.prop..."
                rm $SAUCE/out/target/product/${PRODUCT[$VAL]}/system/build.prop
                echo "done!"
                fi

                
                if [ $QCLEAN = "y" ]; then
                echo -n "Running make install clean..."
                make installclean
                echo "done!"
                fi


# get time of startup
res1=$(date +%s.%N)

# start compilation
make -j8 otapackage

echo "done!"

# finished? get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"

                if [ $MOVE = "y" ]; then
                echo -n "Moving to cloud or storage directory..."
                echo -n "checking for directory, and creating as needed..."
                        mkdir -p $STORAGE
                                if [ $AVF = "y" ]; then
                                        mkdir -p $STORAGE/$VER
                                        mkdir -p $STORAGE/$VER/${PRODUCT[$VAL]}
                                fi
                                if [ $AVF = "n" ]; then
                                        mkdir -p $STORAGE/${PRODUCT[$VAL]}
                                fi
                echo "Done."
                echo "Moving flashable zip..."
                                if [ $AVF = "y" ]; then
                                        mv $SECONDOUTPATH/target/product/${PRODUCT[$VAL]}/$ROM*".zip" $STORAGE/$VER/${PRODUCT[$VAL]}/
                                fi
                                if [ $AVF = "n" ]; then
                                        mv $SECONDOUTPATH/target/product/${PRODUCT[$VAL]}/$ROM*".zip" $STORAGE/${PRODUCT[$VAL]}/
                                fi
                echo "Done."
                fi

done

echo "All done!"

