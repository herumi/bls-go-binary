[![Build Status](https://github.com/herumi/bls-go-binary/actions/workflows/main.yml/badge.svg)](https://github.com/herumi/bls-go-binary/actions/workflows/main.yml)

# bls with compiled static library

This repository contains compiled static library of https://github.com/herumi/bls without `BLS_ETH=1`.

If you want the binary compatible with eth2-spec, then see [bls-eth-go-binary](https://github.com/herumi/bls-eth-go-binary).

* SecretKey; Fr
* PublicKey; G2
* Signature; G1

# How to build the static binary
The following steps are not necessary if you use compiled binary in this repository.

```
git clone --recursive https://github.com/herumi/bls-go-binary
cd bls-go-binary
#git submodule update --init --recursive
```

## Linux, Mac, Windows(mingw64)
clang is necessary to build ll files.
```
make CXX=clang++
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

