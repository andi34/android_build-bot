#!/bin/bash

#
# NOTE: NEVER rename a *.tar.md5! Convert the recovery.img again if you want to rename the file!
#
# Jul 2014 Android-Andi @ XDA
# Thanks to ketut.kumajaya @ XDA
#

#---------------------Device Settings------------------#

# device name in your "out" folder
DEVICENAME1[0]="p5100"
DEVICENAME1[1]="p5110"
#DEVICENAME1[2]="p5100"
#DEVICENAME1[3]="p5110"

# 2nd device name to rename the *.tar.md5 and *.zip the right way
# the odin-flashable tar.md5 will be name like this: DEVICENAME2_ROMNAME_ROMDATE.tar
DEVICENAME2[0]="GT-P5100"
DEVICENAME2[1]="GT-P5110"
#DEVICENAME2[2]="GT-P5100"
#DEVICENAME2[3]="GT-P5110"
#---------------------General Settings------------------#

# select "y" or "n"... Or fill in the blanks... some examples placed in allready.

# recoveryname
ROMNAME="aosp"

# recovery version number
ROMDATE="20150807"

# Your build source code directory path.
# If your source code directory is on an external HDD it should look like: 
# //media/your PC username/the name of your storage device/path/to/your/source/code/folder
SAUCE=~/android/aosp-5.1


#---------------------Convert & Move Code----------------#
# Very much not a good idea to change this unless you know what you are doing....

for VAL in "${!DEVICENAME1[@]}"
do
cd $SAUCE

echo "Moving to out directory ( ${DEVICENAME2[$VAL]} ) ..."
cd $SAUCE/out/target/product/${DEVICENAME1[$VAL]}

echo "Converting recovery.img to a odinflashable *.tar.md5 ..."
tar -H ustar -c boot.img recovery.img system.img > ${DEVICENAME1[$VAL]}"_"$ROMNAME"_"$ROMDATE".tar"
md5sum -t ${DEVICENAME1[$VAL]}"_"$ROMNAME"_"$ROMDATE".tar" >> ${DEVICENAME1[$VAL]}"_"$ROMNAME"_"$ROMDATE".tar"
cp ${DEVICENAME1[$VAL]}"_"$ROMNAME"_"$ROMDATE".tar" ${DEVICENAME1[$VAL]}"_"$ROMNAME"_"$ROMDATE".tar.md5"

echo "Moving back to source directory..."
cd $SAUCE

done

echo "Done!"
