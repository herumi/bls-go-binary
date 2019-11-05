#!/bin/sh
cd jni
ndk-build
cd ..
for i in armeabi-v7a arm64-v8a x86_64; do mkdir -p ../bls/lib/android/$i ; cp obj/local/$i/libbls384_256.a ../bls/lib/android/$i/ ; done
