#!/bin/bash
echo '------------START-------------'
set -x
git pull
git submodule update --remote
git add . && git commit -m '[SHELL]Auto sync upstream repo'
git push
if [ ! -d ../lede ]; then
	git clone https://github.com/coolsnowwolf/lede.git ../lede
fi
cd ../lede
git pull
if [ ! -d package/custom-package ]; then
	ln -sf /opt/src/custom-package package/custom-package
fi
./scripts/feeds update && ./scripts/feeds install
make defconfig
make clean
#make -j$(nproc) download
if [ $? -ne 0 ]; then
    echo "遇到错误."
    exit 1
fi
make menuconfig
make -j$(nproc) V=s
set +x
echo '-----------END--------------'
