#!/bin/bash
echo '------------START-------------'
set -x
git pull
git submodule update --remote
git add . && git commit -m '[*]Auto sync upstream repo'
git push
set +x
echo '-----------END--------------'
