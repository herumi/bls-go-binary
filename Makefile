# ios
XCODEPATH=$(shell xcode-select -p)
IOS_CLANG=$(XCODEPATH)/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
IOS_AR=${XCODEPATH}/Toolchains/XcodeDefault.xctoolchain/usr/bin/ar
PLATFORM?="iPhoneOS"
IOS_MIN_VERSION?=7.0
IOS_CFLAGS=-fembed-bitcode -fno-common -DPIC -fPIC -Dmcl_EXPORTS
IOS_CFLAGS+=-DMCL_USE_VINT -DMCL_VINT_FIXED_BUFFER -DMCL_DONT_USE_OPENSSL -DMCL_DONT_USE_XBYAK -DMCL_LLVM_BMI2=0 -DMCL_USE_LLVM=1 -std=c++11 -Wall -Wextra -Wformat=2 -Wcast-qual -Wcast-align -Wwrite-strings -Wfloat-equal -Wpointer-arith -O3 -DNDEBUG
IOS_CFLAGS+=-I../mcl/include -I../bls/include
IOS_LDFLAGS=-dynamiclib -Wl,-flat_namespace -Wl,-undefined -Wl,suppress
CURVE_BIT?=384_256
IOS_LIB=libbls$(CURVE_BIT).a
IOS_LIBS=ios/armv7/$(IOS_LIB) ios/arm64/$(IOS_LIB) ios/x86_64/$(IOS_LIB) ios/i386/$(IOS_LIB)

all:
	$(MAKE) ios PLATFORM="iPhoneOS" ARCH=armv7 BIT=32 UNIT=4
	$(MAKE) ios PLATFORM="iPhoneOS" ARCH=arm64 BIT=64 UNIT=8
	$(MAKE) ios PLATFORM="iPhoneSimulator" ARCH=x86_64 BIT=64 UNIT=8
	$(MAKE) ios PLATFORM="iPhoneSimulator" ARCH=i386 BIT=32 UNIT=4
	@echo $(IOS_LIBS)
	lipo $(IOS_LIBS) -create -output bls/lib/ios/$(IOS_LIB)

../mcl/src/base64.ll:
	$(MAKE) -C ../mcl src/base64.ll

../mcl/src/base32.ll:
	$(MAKE) -C ../mcl src/base32.ll BIT=32

ios: ../mcl/src/base64.ll ../mcl/src/base32.ll
	@echo "Building iOS $(ARCH) BIT=$(BIT) UNIT=$(UNIT)"
	$(eval IOS_CFLAGS=$(IOS_CFLAGS) -DMCL_SIZEOF_UNIT=$(UNIT))
	@echo IOS_CFLAGS=$(IOS_CFLAGS)
	$(eval IOS_OUTDIR=ios/$(ARCH))
	$(eval IOS_SDK_PATH=$(XCODEPATH)/Platforms/$(PLATFORM).platform/Developer/SDKs/$(PLATFORM).sdk)
	$(eval IOS_COMMON=-arch $(ARCH) -isysroot $(IOS_SDK_PATH) -mios-version-min=$(IOS_MIN_VERSION))
	@mkdir -p $(IOS_OUTDIR)
	$(IOS_CLANG) $(IOS_COMMON) $(IOS_CFLAGS) -c ../mcl/src/fp.cpp -o $(IOS_OUTDIR)/fp.o
	$(IOS_CLANG) $(IOS_COMMON) $(IOS_CFLAGS) -c ../mcl/src/base$(BIT).ll -o $(IOS_OUTDIR)/base$(BIT).o
	$(IOS_CLANG) $(IOS_COMMON) $(IOS_CFLAGS) -c ../bls/src/bls_c$(CURVE_BIT).cpp -o $(IOS_OUTDIR)/bls_c$(CURVE_BIT).o
	ar cru $(IOS_OUTDIR)/$(IOS_LIB) $(IOS_OUTDIR)/fp.o $(IOS_OUTDIR)/base$(BIT).o $(IOS_OUTDIR)/bls_c$(CURVE_BIT).o
	ranlib $(IOS_OUTDIR)/$(IOS_LIB)

update:
	patch -o - -p0 $(BLS_DIR)/ffi/go/bls/mcl.go <patch/mcl.patch > bls/mcl.go
	patch -o - -p0 $(BLS_DIR)/ffi/go/bls/bls.go <patch/bls.patch > bls/bls.go

.PHONY: ios
