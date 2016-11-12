adb push boot.img /sdcard/
adb root
timeout 3
adb shell "dd if=/sdcard/boot.img of=/dev/block/platform/omap/omap_hsmmc.1/by-name/KERNEL"
adb reboot