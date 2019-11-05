# bls with compiled static library

# How to run sample.go
```
go get github.com/herumi/bls-go-binary/
go run sample.go
```

# How to build the static binary
The following steps are not necessary if you use compiled binary in this repository.

# make base32.ll and base64.ll

```
mkdir work
git clone https://github.com/herumi/mcl
git clone https://github.com/herumi/bls
cd mcl
make src/base64.ll
make BIT=32 src/base32.ll
```

* Linux, Mac, Windows(mingw64)
```
cd work/bls
make minimized_static MIN_WITH_XBYAK=1
```

* Android
```
cd android/
./build.sh
```

* iOS
```
make
```

Copy each static library `libbls384_256.a` to `src/bls/lib/<os>/<arch>/`.
