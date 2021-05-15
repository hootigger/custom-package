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
./scripts/feed update && ./scripts/feed install
make menuconfig
set +x
echo '-----------END--------------'
