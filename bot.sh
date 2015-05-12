#!/bin/bash
BASEDIR=$PWD

# Standard init setup
function setup {
echo "Starting setup"
. $BASEDIR/build/envsetup.sh
}

# No need for ccache to just lunch
if [ "$1" = "lunch" ] ; then
    echo "Lets just lunch a device"
    setup
    lunch slim_$2-userdebug
    exit
fi

# Exporting CCache crap
echo "Settting up ccache"
export CCACHE_DIR="/home/android-andi/cache"
export CCACHE_HARDLINK="0"
export CCACHE_LOGFILE="/home/android-andi/cache/rom.log"
export CCACHE_UMASK="002"
export USE_CCACHE=1
#export CCACHE_BASEDIR=$PWD

setup
lunch $1_$2-userdebug

#Adding specifics for installclean, clean or clobber
if [ "$3" = "ic" ] ; then
    make installclean
fi
if [ "$3" = "clean" ] ; then
    make clean
fi
if [ "$3" = "clobber" ] ; then
    make clobber
fi

START=$(date +%s)
make -j$4 bacon
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "Device $2 make $3 -j$4 took $DIFF seconds on $BASEDIR" >> ~/tracebuildtime.time
echo "Done!"
