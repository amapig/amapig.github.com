#!/bin/bash

NDK=/usr/src/android-ndk-r9

case $1 in
	neon)
		ARCH=arm
		CPU=armv7-a
		EXTRA_CFLAGS="-mfloat-abi=softfp -mfpu=neon -mtune=cortex-a8 -mvectorize-with-neon-quad"
		EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"
		EXTRA_PARAMETERS="--disable-fast-unaligned"
		;;
	tegra2)
		ARCH=arm
		CPU=armv7-a
		EXTRA_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16"
		EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"
		;;
	v6_vfp)
		ARCH=arm
		CPU=armv6
		EXTRA_CFLAGS="-mfloat-abi=softfp -mfpu=vfp"
		;;
	v6)
		ARCH=arm
		CPU=armv6
		EXTRA_CFLAGS="-msoft-float"
		;;
	v5te)
		ARCH=arm
		CPU=armv5te
		EXTRA_CFLAGS="-msoft-float -mtune=xscale"
		;;
	x86_sse3)
		ARCH=x86
		CPU=i686
		EXTRA_CFLAGS="-O3 -mtune=atom -msse3 -mfpmath=sse"
		;;
	x86_sse2)
		ARCH=x86
		CPU=i686
		EXTRA_CFLAGS="-O3 -msse2 -mfpmath=sse"
		EXTRA_PARAMETERS="--disable-sse3"
		;;
	mips)
		ARCH=mips
		CPU=mips32r2
		EXTRA_CFLAGS=
		EXTRA_PARAMETERS="--disable-mipsfpu --disable-mipsdspr1 --disable-mipsdspr2"
		;;
	*)
		echo Unknown target: $1
		exit
esac

INC_OPENSSL=../openssl-1.0.0d/include
INC_OPUS=../opus/include
INC_SPEEX=../speex/include

if [ $ARCH == 'arm' ] 
then
	CROSS_PREFIX=$NDK/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86/bin/arm-linux-androideabi-
	EXTRA_CFLAGS="$EXTRA_CFLAGS -fstack-protector -fstrict-aliasing"
	OPTFLAGS="-O2"
	LIB_MX="../libs/armeabi-v7a/neon"
	EXTRA_LDFLAGS+=" -march=$CPU"
	LIB_OPENSSL=../libs/android/16-$ARCH
elif [ $ARCH == 'x86' ] 
then
	CROSS_PREFIX=$NDK/toolchains/x86-4.6/prebuilt/linux-x86/bin/i686-linux-android-
	EXTRA_CFLAGS="$EXTRA_CFLAGS -fstrict-aliasing"
	OPTFLAGS="-O2 -fno-pic"
	LIB_MX="../libs/x86-sse3"
	LIB_OPENSSL=../libs/android/16-$ARCH
elif [ $ARCH == 'mips' ] 
then
	CROSS_PREFIX=$NDK/toolchains/mipsel-linux-android-4.6/prebuilt/linux-x86/bin/mipsel-linux-android-
	EXTRA_CFLAGS="$EXTRA_CFLAGS -fno-strict-aliasing -fmessage-length=0 -fno-inline-functions-called-once -frerun-cse-after-loop -frename-registers"
	OPTFLAGS="-O2"
	LIB_MX="../libs/mips"
	# Due to reference to missing symbol __fixdfdi on Novo 7 Paladin.
	LIB_OPENSSL=../libs/android/15-$ARCH
fi

./configure \
--enable-static \
--disable-shared \
--enable-optimizations \
--disable-doc \
--disable-symver \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-ffserver \
--disable-avdevice \
--disable-encoders \
--disable-muxers \
--disable-devices \
--disable-parser=dca \
--disable-demuxer=srt \
--disable-demuxer=microdvd \
--disable-demuxer=jacosub \
--disable-demuxer=sami \
--disable-demuxer=realtext \
--disable-demuxer=dts \
--disable-demuxer=subviewer \
--disable-demuxer=webvtt \
--disable-demuxer=subviewer1 \
--disable-demuxer=pjs \
--disable-demuxer=vplayer \
--disable-demuxer=mpl2 \
--disable-decoder=ass \
--disable-decoder=srt \
--disable-decoder=subrip \
--disable-decoder=microdvd \
--disable-decoder=jacosub \
--disable-decoder=sami \
--disable-decoder=realtext \
--disable-decoder=dca \
--disable-decoder=movtext \
--disable-decoder=subviewer \
--disable-decoder=webvtt \
--disable-decoder=subviewer1 \
--disable-decoder=pjs \
--disable-decoder=vplayer \
--disable-decoder=mpl2 \
--enable-openssl \
--enable-zlib \
--enable-pic \
--enable-libopus \
--enable-libspeex \
--disable-debug \
--arch=$ARCH \
--cpu=$CPU \
--cross-prefix=$CROSS_PREFIX \
--enable-cross-compile \
--sysroot=$NDK/platforms/android-9/arch-$ARCH \
--target-os=linux \
--extra-cflags="-I$INC_OPENSSL -I$INC_OPUS -I$INC_SPEEX -DNDEBUG -DMXTECHS -mandroid -ftree-vectorize -ffunction-sections -funwind-tables -fomit-frame-pointer -funswitch-loops -finline-limit=300 -finline-functions -fpredictive-commoning -fgcse-after-reload -fipa-cp-clone $EXTRA_CFLAGS -no-canonical-prefixes" \
--extra-ldflags="-L$LIB_MX -L$LIB_OPENSSL -lmxutil -lm $EXTRA_LDFLAGS" \
--optflags="$OPTFLAGS" \
$EXTRA_PARAMETERS

