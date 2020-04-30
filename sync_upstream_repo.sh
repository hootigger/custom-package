#!/bin/bash -x 
echo '------------START-------------'
git pull
echo '-------------------------'
git submodule update --remote
echo '-------------------------'
git add . && git commit -m 'auto sync upstream repo'
git push
echo '-----------END--------------'
