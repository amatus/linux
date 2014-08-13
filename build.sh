#!/bin/sh
#
# kernel build script for apollo3g 
#
# Usage: 'sh build.sh' to just use defaults (need to have the ELDK installed)
#        'sh build.sh CROSS_COMPILE ARCH OUTLOC' to specifiy all parameters
#
_CROSS_COMPILE=${1:-ppc_4xxFP-}
_ARCH=${2:-powerpc}
OUTLOC=${3:-_BuildOutput}
if [ ! -d ${OUTLOC} ]; then 
    mkdir -p "${OUTLOC}"
fi

echo =========== Building Linux ===============
make distclean
make mrproper
make O=${OUTLOC} CROSS_COMPILE=${_CROSS_COMPILE} ARCH=${_ARCH} 44x/apollo_3G_nas_defconfig
make O=${OUTLOC} CROSS_COMPILE=${_CROSS_COMPILE} ARCH=${_ARCH} -j 5 uImage

echo
echo =========== Building device tree ===========
make O=${OUTLOC} CROSS_COMPILE=${_CROSS_COMPILE} ARCH=${_ARCH} -j 5 apollo3g.dtb

echo
echo "=========== Copying images to directory $(pwd) ==============="
cp -v ${OUTLOC}/arch/powerpc/boot/uImage .
cp -v ${OUTLOC}/arch/powerpc/boot/apollo3g.dtb .
ls -ll *.dtb uImage

# We don't use the combined image
#echo
#echo =========== Combining images ===============
#dd if=/dev/zero of=apollo3g_boot.img bs=1 count=5M
#dd if=${OUTLOC}/arch/powerpc/boot/uImage of=apollo3g_boot.img conv=notrunc bs=1
#dd if=${OUTLOC}/arch/powerpc/boot/apollo3g.dtb of=apollo3g_boot.img conv=notrunc bs=1 seek=4M


#
# original beech script... 
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

