[![Build Status](https://github.com/herumi/bls-go-binary/actions/workflows/main.yml/badge.svg)](https://github.com/herumi/bls-go-binary/actions/workflows/main.yml)

# bls with compiled static library

This repository contains compiled static library of https://github.com/herumi/bls without `BLS_ETH=1`.
See [releases](https://github.com/herumi/bls-go-binary/releases/).

If you want the binary compatible with eth2-spec, then see [bls-eth-go-binary](https://github.com/herumi/bls-eth-go-binary).

* SecretKey; Fr
* PublicKey; G2
* Signature; G1

# News
- 2023/Aug/17 The performance of Sign is a little improved.

# How to build the static binary
The following steps are not necessary if you use compiled binary in this repository.

```
git clone --recursive https://github.com/herumi/bls-go-binary
cd bls-go-binary
#git submodule update --init --recursive
```

## Linux, Mac, Windows(mingw64)
On x64 Linux,
```
make
```

Otherwise, clang is necessary to build ll files.
```
make CXX=clang++
```

### Cross compile on macOS

```
make ARCH=x86_64 # for Intel mac
make ARCH=arm64  # for M1 mac
```

### Cross compile of aarch64 on x64 Linux

```
sudo apt-get install gcc-multilib
make -C src/bls -f Makefile.onelib build_aarch64 CXX=clang++ -j OUT_DIR=../..
```

# Android
```
make android
```

If you need a shared library, then after `make clean`,

```
make android BLS_LIB_SHARED=1
```

# iOS
```
make ios
```

# how to release (internal notification)
```
git checkout -b release
git reset --hard origin/release
git merge origin/master
git push origin release
```

# Author

MITSUNARI Shigeo(herumi@nifty.com)

# Sponsors welcome
[GitHub Sponsor](https://github.com/sponsors/herumi)
