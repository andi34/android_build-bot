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

mexit() { echo "$1"; exit $2; }
prompterr() { read -p "Continue? ($2/N) " prompt; [ "$prompt" = "$2" ] || exit 0; }

JAVAVERTARGET=8
# Check for Java version first
echo "Checking Java Version..."
# adapted from http://notepad2.blogspot.de/2011/05/bash-script-to-check-java-version.html
JAVAVER=`java -version 2>&1 | grep "java version" | awk '{print $3}' | tr -d \" | awk '{split($0, array, ".")} END{print array[2]}'`
if [[ $JAVAVER = $JAVAVERTARGET ]]; then
    echo "Java version OK."
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
    echo " #"
    echo " #####################################################"
    prompterr "Wrong Java version." "y"
fi

echo "blablabla"
echo "blablabla"
echo "blablabla"
echo "blablabla"