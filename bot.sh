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

PRODUCT[0]="espressowifi"                        # phone model name (product folder name)
LUNCHCMD[0]="espressowifi"                        # lunch command used for ROM

PRODUCT[1]="espresso3g"
LUNCHCMD[1]="espresso3g"

#---------------------Build Settings------------------#

# use ccache
CCACHE=y

# what dir for ccache?
CCSTORAGE=/ssd1/ccache

# new out path
OUTPATH=/ssd2/out

# should they be moved out of the output folder?
MOVE=y

# Sync repositories before build
SYNC=y

# run mka installclean first (quick clean build)
QCLEAN=y

# Run make clean first (Slow clean build. Will delete entire contents of out folder...)
CLEAN=y

# Run make clobber first (Realy slow clean build. Deletes all the object files AND the intermediate dependency files generated which specify the dependencies of the cpp files.)
CLOBBER=y


SAUCE=~/android/$BRANCH
SECONDOUTPATH=$OUTPATH/$BRANCH

# leave alone
DATE=`eval date +%y``eval date +%m``eval date +%d`

#---------------------Build Bot Code-------------------#
# Very much not a good idea to change this unless you know what you are doing....

# Check for Java version first
echo "Checking Java Version..."
# adapted from http://notepad2.blogspot.de/2011/05/bash-script-to-check-java-version.html
JAVAVER=`java -version 2>&1 | grep "java version" | awk '{print $3}' | tr -d \" | awk '{split($0, array, ".")} END{print array[2]}'`
if [[ $JAVAVER = $JAVAVERTARGET ]]; then
    echo "Java version OK."

echo -n "Moving to source directory..."
cd $SAUCE
echo "done!"

echo "change path for out directory"
export OUT_DIR_COMMON_BASE=$OUTPATH
echo "done!"

if [ "$SYNC" = "y" ]; then
        echo -n "Running repo sync..."
        repo sync -d -f -j8 --force-sync
        echo "done!"
        if [ "$STABLEKERNEL" = "y" ]; then
                cd $SAUCE/kernel/samsung/espresso10
                git remote add omap4aosp https://github.com/OMAP4-AOSP/android_kernel_samsung_espresso.git
                git fetch omap4aosp
                git checkout omap4aosp/stable
                cd $SAUCE
        fi
        if [ "$TAB2CHANGES" = "y" ]; then
                cd $SAUCE
                . pull/tab2
                if [ "$1" = "lp5.1" ]; then
                    . pull/globalmenu
                fi
        fi

        if [ "$UPLOADCROWDIN" = "y" ]; then
                cd $SAUCE
                if [ "$1" = "android-6.0" ]; then
                    ./crowdin_sync.py -u Android-Andi -b android-6.0 --upload-sources
                    #./crowdin_sync.py -u Android-Andi -b android-6.0 --download
                fi
                if [ "$1" = "mm6.0" ]; then
                    ./crowdin_sync.py -u andi34 -b mm6.0 --upload-sources
                    #./crowdin_sync.py -u andi34 -b mm6.0 --download
                    #. pull/translation
                fi
                cd $SAUCE

        fi
fi

if [ "$CCACHE" = "y" ]; then
                        export USE_CCACHE=1
                        export CCACHE_DIR=$CCSTORAGE
                        # set ccache due to your disk space,set it at your own risk
                        prebuilts/misc/linux-x86/ccache/ccache -M 100G
                fi

for VAL in "${!PRODUCT[@]}"
do

echo -n "Starting build..."
. build/envsetup.sh
croot
lunch "$LUNCHROM"_${LUNCHCMD[$VAL]}-userdebug

if [ "$BP" = "y" ]; then
        echo "Removing build.prop..."
        rm $SECONDOUTPATH/target/product/${PRODUCT[$VAL]}/system/build.prop
        echo "done!"
fi

if [ "$QCLEAN" = "y" ]; then
        echo -n "Running make install clean..."
        make installclean
        echo "done!"
fi

if [ "$CLEAN" = "y" ]; then
        echo -n "Running make clean..."
        make clean
        echo "done!"
fi

if [ "$CLOBBER" = "y" ]; then
        echo -n "Running make clobber..."
        make clobber
        echo "done!"
fi


# get time of startup
res1=$(date +%s.%N)

# start compilation
make bacon -j8

echo "done!"

# finished? get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"


                echo -n "Moving to cloud or storage directory..."
                echo -n "checking for directory, and creating as needed..."
                        mkdir -p $STORAGE
                        mkdir -p $STORAGE/$VER
                        mkdir -p $STORAGE/$VER/${PRODUCT[$VAL]}

                echo "Moving flashable zip..."
                        mv $SECONDOUTPATH/target/product/${PRODUCT[$VAL]}/$ROM*".zip" $STORAGE/$VER/${PRODUCT[$VAL]}/

                echo -n "Moving md5..."
                        mv $SECONDOUTPATH/target/product/${PRODUCT[$VAL]}/*".md5sum" $STORAGE/$VER/${PRODUCT[$VAL]}/

                echo -n "Moving recovery.img..."
                        cp -r $SECONDOUTPATH/target/product/${PRODUCT[$VAL]}/"recovery.img" $STORAGE/$VER/${PRODUCT[$VAL]}/

done

make clobber

echo "All done!"

else
    echo " #####################################################"
    echo " #"
    echo " # Wrong Java version."
    echo " # Your Java version is $JAVAVER ; needed is $JAVAVERTARGET"
    echo " #"
    echo " #"
    echo " #"
    echo " # Please run:"
    echo " #"
    echo " #   sudo update-alternatives --config java"
    echo " #"
    echo " # and"
    echo " #"
    echo " #   sudo update-alternatives --config javac"
    echo " #"
    echo " # and choose the right Java version!"
    echo " #"
    echo " # Aborted!"
    echo " #"
    echo " #####################################################"
fi
