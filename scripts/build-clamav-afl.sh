#!/usr/bin/env bash
set -e

export CC=afl-clang-fast
export CXX=afl-clang-fast++

mkdir -p /work/build-clamav
cd /work/build-clamav

cmake /opt/clamav \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo

ninja
