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
export CCACHE_DIR="/home/robbiel811/.ccache"
export CCACHE_HARDLINK="0"
export CCACHE_LOGFILE="/home/robbiel811/.ccache/logfiles/robbiel811.log"
export CCACHE_UMASK="002"
export USE_CCACHE=1
#export CCACHE_BASEDIR=$PWD

setup
lunch slim_$1-userdebug

#Adding specifics for installclean or clean
if [ "$3" = "ic" ] ; then
    make installclean
fi
if [ "$3" = "clean" ] ; then
    make clean
fi
if [ "$3" = "clobber" ] ; then
    make clobber
fi

# Add Slim Release type
if [ "$4" = "r" ] ; then
    export SLIM_BUILD_TYPE=OFFICIAL;
fi
if [ "$4" = "w" ] ; then
    export SLIM_BUILD_TYPE=WEEKLY;
fi

# Add kernel compile bit
if [ "$2" = "kernel" ] ; then
    START=$(date +%s)
    make bootzip -j15
    ND=$(date +%s)
    DIFF=$(( $END - $START ))
    echo "Kernel for $1 make $3 -j$2 took $DIFF seconds on $BASEDIR" >> ~/tracebuildtime.time
sendmail <receiver@email> -f <sender@email><<EOF
Subject: Build completed!
Kernel for $1 make -j15 took $DIFF seconds on $BASEDIR
Done
cya!
EOF
    exit
fi

START=$(date +%s)
make -j$2 bacon
END=$(date +%s)
DIFF=$(( $END - $START ))
echo "Device $1 make $3 -j$2 took $DIFF seconds on $BASEDIR" >> ~/tracebuildtime.time

sendmail <receiver@email> -f <sender@email><<EOF
Subject: Build Finished
Device $1 make -j$2 took $DIFF seconds on $BASEDIR
Done
cya!
EOF
