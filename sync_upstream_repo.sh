#!/bin/bash
echo '------------START-------------'
set -x

# 上游仓库配置（后续切换分支只需修改 REPO_BRANCH）
REPO_URL="https://github.com/immortalwrt/immortalwrt.git"
REPO_BRANCH="openwrt-24.10"
REPO_DIR="../immortalwrt"

git pull
git submodule update --remote --depth 1
git add . && git commit -m '[SHELL]Auto sync upstream repo'
git push
if [ ! -d "$REPO_DIR" ]; then
	git clone --depth 1 --single-branch -b "$REPO_BRANCH" "$REPO_URL" "$REPO_DIR"
fi
cd "$REPO_DIR"
git pull --depth 1

# 检查 feeds.conf.default 是否已引入 custom-package，若无则添加
FEEDS_CONF="feeds.conf.default"
CUSTOM_PKG_PATH="/opt/src/custom-package"
if [ -f "$FEEDS_CONF" ] && ! grep -q "src-link custom-package" "$FEEDS_CONF"; then
	echo "src-link custom-package $CUSTOM_PKG_PATH" >> "$FEEDS_CONF"
fi

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
