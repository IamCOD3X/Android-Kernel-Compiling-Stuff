#!/bin/bash
#
# Compile script for ViP3R-KENREL
# Copyright (C) 2020-2021 Adithya R.

SECONDS=0 # builtin bash timer
ZIPNAME="ViP3R-v1.0-India-$(date '+%Y%m%d-%H%M').zip"
TC_DIR="home/cod3x/Android/Kernels/ToolChains/clang-14.0.7"
GCC_64_DIR="/home/cod3x/Android/Kernels/ToolChains/gcc"
GCC_32_DIR="/home/cod3x/Android/Kernels/ToolChains/gcc32"
AK3_DIR="home/cod3x/Android/Kernels/Anykernel3"
DEFCONFIG="nethunter_defconfig"
LINKER=ld.lld
export PATH="$TC_DIR/bin:$PATH"

export KBUILD_BUILD_USER=IamCOD3X
export KBUILD_BUILD_HOST=cod3x

if test -z "$(git rev-parse --show-cdup 2>/dev/null)" &&
   head=$(git rev-parse --verify HEAD 2>/dev/null); then
	ZIPNAME="${ZIPNAME::-4}-$(echo $head | cut -c1-8).zip"
fi

if [[ $1 = "-r" || $1 = "--regen" ]]; then
make O=out ARCH=arm64 $DEFCONFIG savedefconfig
cp out/defconfig arch/arm64/configs/$DEFCONFIG
exit
fi

if [[ $1 = "-c" || $1 = "--clean" ]]; then
rm -rf out
fi

mkdir -p out
make O=out ARCH=arm64 $DEFCONFIG

echo -e "\nStarting compilation...\n"
make -j$(nproc --all) O=out ARCH=arm64 CC=clang LD=$LINKER AR=llvm-ar AS=llvm-as NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip CROSS_COMPILE=$GCC_64_DIR/bin/aarch64-linux-android- CROSS_COMPILE_ARM32=$GCC_32_DIR/bin/arm-linux-androideabi- CLANG_TRIPLE=aarch64-linux-gnu- Image.gz-dtb dtbo.img

if [ -f "out/arch/arm64/boot/Image.gz-dtb" ] && [ -f "out/arch/arm64/boot/dtbo.img" ]; then
echo -e "\nKernel compiled succesfully! Zipping up...\n"
if [ -d "$AK3_DIR" ]; then
cp -r $AK3_DIR AnyKernel3
elif ! git clone -q https://github.com/IamCOD3X/Anykernel3; then
echo -e "\nAnyKernel3 repo not found locally and cloning failed! Aborting..."
exit 1
fi
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3
cp out/arch/arm64/boot/dtbo.img AnyKernel3
rm -f *zip
cd AnyKernel3
git checkout master &> /dev/null
zip -r9 "../$ZIPNAME" * -x '*.git*' README.md *placeholder
cd ..
rm -rf AnyKernel3
rm -rf out/arch/arm64/boot
echo -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"
echo "Zip: $ZIPNAME"
[ -x "$(command -v gdrive)" ] && gdrive upload --share "$ZIPNAME"
else
echo -e "\nCompilation failed!"
exit 1
fi
