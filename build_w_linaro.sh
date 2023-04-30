#!/bin/bash
TD=home/cod3x/Andorid/Kernels/ToolChains
function compile() 
{

source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
ccache -M 100G
export ARCH=arm64
export KBUILD_BUILD_HOST=Ryzen
export KBUILD_BUILD_USER="COD3X"

[ -d "out" ] && rm -rf out || mkdir -p out

make O=out ARCH=arm64 nethunter_defconfig

PATH="${TD}/clang/bin:${PATH}:${TD}/los-4.9-32/bin:${PATH}:${TD}/los-4.9-64/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC="clang" \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE="${TD}/los-4.9-64/bin/aarch64-linux-gnu-" \
                      CROSS_COMPILE_ARM32="${TD}/los-4.9-32/bin/arm-linux-gnueabihf-" \
                      # CONFIG_NO_ERROR_ON_MISMATCH=y
}



compile
