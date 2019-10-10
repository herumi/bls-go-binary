# bls with compiled static library

# How to run sample.go
```
go get github.com/herumi/bls-go-binary/src
go run sample.go
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
```

* Android
```
cd android
ndk-build
```

* iOS
```
make
```

Copy each static library `libbls384_256.a` to `src/bls/lib/<os>/<arch>/`.
