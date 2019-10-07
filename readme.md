# bls with compiled static library

# How to run sample.go
```
env GOPATH=`pwd` go run sample.go
```

# How to build

* Linux, Mac, Windows(mingw64)
```
mkdir work
git clone htpps://github.com/herumi/mcl
git clone htpps://github.com/herumi/bls
cd mcl
make src/base64.ll
make BIT=32 src/base32.ll
cd ../bls
make minimized_static MIN_WITH_XBYAK=1
cp lib/lib384_256.a ../bls-go-binary/src/lib/lib384_256_<os>.a
```

* Android
```
cd android
ndk-build
```