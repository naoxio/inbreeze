#!/usr/bin/env sh
set -eu

pub_cache="${PUB_CACHE:-$HOME/.pub-cache}"
sed -i -e 's/-Wl,/-Wl,--build-id=none,/' "$pub_cache"/hosted/pub.dev/jni-*/src/CMakeLists.txt
