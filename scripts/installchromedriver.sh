#!/bin/bash
# https://gist.github.com/mikesmullin/2636776#gistcomment-1658459
a=$(uname -m) &&
[[ -d /tmp/chromedriver ]] && rm -rf /tmp/chromedriver
mkdir -p /tmp/chromedriver/ &&
wget -O /tmp/chromedriver/LATEST_RELEASE http://chromedriver.storage.googleapis.com/LATEST_RELEASE &&
if [ $a == i686 ]; then b=32; elif [ $a == x86_64 ]; then b=64; fi &&
latest=$(cat /tmp/chromedriver/LATEST_RELEASE) &&
wget -O /tmp/chromedriver/chromedriver.zip 'http://chromedriver.storage.googleapis.com/'$latest'/chromedriver_linux'$b'.zip' &&
unzip /tmp/chromedriver/chromedriver.zip chromedriver -d /usr/local/bin/