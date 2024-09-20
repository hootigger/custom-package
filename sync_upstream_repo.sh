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
cd ../immortalwrt
git pull
#if [ ! -d package/custom-package ]; then
	#ln -sf /opt/src/custom-package package/custom-package
#fi
./scripts/feeds update -a && ./scripts/feeds install -a
exit 0
make defconfig
make clean
if [[ $1 == "all" ]]; then
	make dirclean
fi
#make -j$(nproc) download
if [ $? -ne 0 ]; then
    echo "遇到错误."
    exit 1
fi
make menuconfig
make -j$(nproc) V=s
set +x
echo '-----------END--------------'
