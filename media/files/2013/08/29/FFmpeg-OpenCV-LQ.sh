#!/bin/sh

NDK=/home/b375/android-ndk-r8d
PLATFORM=$NDK/platforms/android-9/arch-x86
PREBUILT=$NDK/toolchains/x86-4.4.3/prebuilt/linux-x86
PREFIX=/home/qiang/ffmpeg/
ANDROID_SOURCE=/home/qiang/android/mainline
EXTRA_CFLAGS="-I/home/qiang/ffmpeg/ffinc -fPIC -DANDROID"
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/base/include -I$ANDROID_SOURCE/system/core/include"
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/av/media/libstagefright -I$ANDROID_SOURCE/frameworks/native/include"
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/native/include/media/openmax -I$ANDROID_SOURCE/frameworks/av/include"
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$NDK/sources/cxx-stl/gnu-libstdc++/4.4.3/include -I$NDK/sources/cxx-stl/gnu-libstdc++/4.4.3/libs/x86/include"
ANDROID_LIBS=/home/qiang/android/mainline/out/target/product/redhookbay/system/lib
EXTRA_CXXFLAGS="-Wno-multichar -fno-exceptions -fno-rtti"

./configure --target-os=linux --prefix=$PREFIX \
    --libdir=$PREFIX/fflib \
    --shlibdir=$PREFIX/fflib \
    --incdir=$PREFIX/ffinc \
    --bindir=$PREFIX/bin \
    --enable-cross-compile \
    --enable-runtime-cpudetect \
    --enable-pic \
    --disable-shared \
    --disable-symver \
    --arch=x86 \
    --disable-asm \
    --cc=$PREBUILT/bin/i686-linux-android-gcc \
    --cross-prefix=$PREBUILT/bin/i686-linux-android- \
    --enable-stripping \
    --nm=$PREBUILT/bin/i686-linux-android-nm \
    --sysroot=$PLATFORM \
    --disable-nonfree \
    --disable-gpl \
    --disable-doc \
    --enable-avresample \
    --enable-demuxer=rtsp \
    --enable-muxer=rtsp \
    --disable-ffplay \
    --enable-avfilter \
    --disable-ffserver \
    --enable-ffmpeg \
    --enable-libstagefright-h264 \
    --disable-libx264 \
    --disable-ffprobe \
    --enable-protocol=rtp \
    --enable-hwaccels \
    --enable-zlib \
    --enable-pthreads \
    --disable-devices \
    --disable-avdevice \
    --extra-ldflags="-llog -L$ANDROID_LIBS -Wl,-rpath-link,$ANDROID_LIBS -L$NDK/sources/cxx-stl/gnu-libstdc++/4.4.3/libs/x86" \
    --extra-cflags="$EXTRA_CFLAGS" \
    --extra-cxxflags="$EXTRA_CXXFLAGS" 

sudo make -j4 install
