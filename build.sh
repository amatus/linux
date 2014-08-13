#!/bin/sh

#
# build support for apollo3g
#
local _CROSS_COMPILE=${1:-"ppc_4xxFP-"}
local _ARCH=${2:-"powerpc"}

if [ ! -z ${3} ]; then
    if [ ! -d ${3} ]; then 
        mkdir -p "${3}"
    fi
    OUTPREFIX="${3}/"
    OUTLOC="O=${3}"
fi

#echo "CROSS_COMPILE=${_CROSS_COMPILE} ARCH=${_ARCH} OUTLOC=${OUTLOC}"

echo =========== Building Linux ===============
make distclean
make mrproper
make ${OUTLOC} CROSS_COMPILE=${_CROSS_COMPILE} ARCH=${_ARCH} 44x/apollo_3G_nas_defconfig
make ${OUTLOC} CROSS_COMPILE=${_CROSS_COMPILE} ARCH=${_ARCH} -j 5 uImage

echo
echo =========== Building device tree ===========
make ${OUTLOC} CROSS_COMPILE=${_CROSS_COMPILE} ARCH=${_ARCH} -j 5 apollo3g.dtb

echo
echo =========== Combining images ===============
dd if=/dev/zero of=apollo3g_boot.img bs=1 count=5M
dd if=${OUTPREFIX}arch/powerpc/boot/uImage of=apollo3g_boot.img conv=notrunc bs=1
dd if=${OUTPREFIX}arch/powerpc/boot/apollo3g.dtb of=apollo3g_boot.img conv=notrunc bs=1 seek=4M

echo
ls -ll apollo3g_boot.img

#
# beech ?
#

#echo =========== Building Linux ===============
#make distclean
#make 44x/beech_nas_optimized_defconfig
#make uImage
#
#echo =========== Building device tree ===========
#make beech.dtb
#
#echo =========== Combining images ===============
#dd if=/dev/zero of=beech_boot.img bs=1 count=5M
#dd if=arch/powerpc/boot/uImage of=beech_boot.img conv=notrunc bs=1
#dd if=arch/powerpc/boot/beech.dtb of=beech_boot.img conv=notrunc bs=1 seek=4M

