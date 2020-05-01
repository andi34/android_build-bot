
## Kernel compilation scripts by Andreas Blaesius

## Ready to use

The source is setup to compile and generate an AnyKernel2 zip for different devices if you've setup your sources using the manifest from [here](https://github.com/andi34/android_build-bot/blob/manifest/README.md).

Once you have the source synced `cd` into the `build` repository (`cd build`) to be ready to compile.

## Supported devices

- Samsung Galaxy Tab 2 Family (P31XX & P51XX).
  - For Android 5.0 - Android 7.1.2:
    - espressowifi and espresso3g: Run `. espresso_m.sh`
    - p3100: Run `. espressovariants/p3100.sh`
    - p3110: Run `. espressovariants/p3110.sh`
    - p3113: Run `. espressovariants/p3113.sh`
    - p5100: Run `. espressovariants/p5100.sh`
    - p5110: Run `. espressovariants/p5110.sh`
    - p5113: Run `. espressovariants/p5113.sh`
  - For Android 4.4.4:
    - espressowifi and espresso3g: Run `. espresso_k.sh`
    - p3100: Run `. espressovariants/p3100-k.sh`
    - p3110: Run `. espressovariants/p3110-k.sh`
    - p3113: Run `. espressovariants/p3113-k.sh`
    - p5100: Run `. espressovariants/p5100-k.sh`
    - p5110: Run `. espressovariants/p5110-k.sh`
    - p5113: Run `. espressovariants/p5113-k.sh`

- Samsung Galaxy Nexus (Maguro, Toro, Toroplus)
  - For Android 5.0 - Android 7.1.2:
    - tuna: Run `. tuna_m.sh`
  - For Android 4.4.4:
    - tuna: Run `. tuna_k.sh`

- OnePlus One (Bacon)
  - For Android 5.0 - Android 7.1.2:
    - bacon: Run `. bacon_m.sh`

- Samsung S3 mini (Golden)
  - For Android 4.4.4:
    - tuna: Run `. golden.sh`

## AnyKernel2

For all supported Devices an AnyKernel2 is generated automatically and can be found at `AnyKernel/$ANYKERNEL_DEVICE` after compilation.

## Options

### General

| Option           | Description                                                                                                                     |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| KERNELSOURCE     | Path to your Kernel source.                                                                                                     |
| TOOLCHAIN        | Toolchain used for kernel compilation. Available options: `gcc4.7`, `gcc4.8`, `gcc4.9`, `linaro4.7-13.04`, `linaro4.7-14.01`.   |
| DEFCONFIGNAME    | Defconfig used for kernel compilation.                                                                                          |
| WORKINGDIR       | KERNEL_OUT directory.                                                                                                           |
| WORKINGOUTDIR    | Folder to store compiled zImage and modules after compilation. **Gets removed on re-compilation**.                              |
| ANYKERNEL_DEVICE | Name used for AnyKernel generation (Path need to exist at `AnyKernel/$ANYKERNEL_DEVICE`).                                       |
| ANYKERNEL_SCRIPT | Script to run to generate AnyKernel after compilation. Need to exist inside `AnyKernel/$ANYKERNEL_DEVICE/`.                     |

### OMAP4 specific options

| Option           | Description                                                                                                                     |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| VARIANTDEFCONFIG | Variant specific defconfig used for kernel compilation.                                                                         |
| PVRSAUCE         | Path to PVR module source.                                                                                                      |
| NEWDDK           | Options: `y` (for ROMs using DDK 1.14), `n` (for ROMs using DDK 1.9).                                                           |

#### Example omap4 specific config for ROMs using DDK 1.14:
```
PVRSAUCE=$SAUCE/pvr-source/ddk-1.14/eurasiacon
NEWDDK="y"
```
or for GPU-OC by default (also needs to be enabled in your defconfig)
```
PVRSAUCE=$SAUCE/pvr-source/ddk-1.14-oc/eurasiacon
NEWDDK="y"
```

#### Example omap4 specific config for ROMs using DDK 1.9:
```
PVRSAUCE=$SAUCE/pvr-source/ddk-1.9/eurasiacon
NEWDDK="n"
```
or for GPU-OC by default (also needs to be enabled in your defconfig)
```
PVRSAUCE=$SAUCE/pvr-source/ddk-1.9-oc/eurasiacon
NEWDDK="n"
```

#### ROMs by [Android-Andi](https://forum.xda-developers.com/member.php?u=5153662) using DDK 1.14:

Slim6, Slim7, OmniROM4, OmniROM 6, OmniROM 7, LineageOS 11, LineageOS 13 and LineageOS 14.1 **compiled after 01.03.2019**.

