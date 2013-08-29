---
title: '白话FFmpeg--(四)自己编写Android.mk来编译FFmpeg'
layout: post
tags:
    - FFmpeg
---

###1. 编写config.sh
FFmpeg支持非常多的config，来确保编译出来的库是我们需要的版本，在编译FFmpeg之前，我们需要对FFmpeg进行相应的配置。

一般情况下，需要我们自己定义一个config.sh文件，放在ffmpeg根目录下，文件内容如下：

    ./configure \
    --disable-static \
    --enable-shared \
    --enable-version3 \
    --enable-nonfree \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-avdevice \
    --disable-avfilter \
    --disable-postproc \
    --enable-small \
    --cross-prefix=/home/b618/androidProject/oldbbdev/bbdev/bbdev/prebuilt/linux-x86/toolchain/i686-android-linux-4.4.3/bin/i686-android-linux- \
    --enable-cross-compile \
    --target-os=linux \
    --extra-cflags='-I/home/b618/androidProject/newbbdev/bbdev/prebuilt/ndk/android-ndk-r4/platforms/android-8/arch-x86/usr/include' \
    --extra-ldflags='-L/home/b618/androidProject/newbbdev/bbdev/prebuilt/ndk/android-ndk-r4/platforms/android-8/arch-x86/usr/lib -nostdlib' \
    --arch=x86 \
    --disable-symver \
    --disable-debug \
    --disable-stripping \
    
	sed -i 's/HAVE_LRINT 0/HAVE_LRINT 1/g' config.h
	sed -i 's/HAVE_LRINTF 0/HAVE_LRINTF 1/g' config.h
	sed -i 's/HAVE_ROUND 0/HAVE_ROUND 1/g' config.h
	sed -i 's/HAVE_ROUNDF 0/HAVE_ROUNDF 1/g' config.h
	sed -i 's/HAVE_TRUNC 0/HAVE_TRUNC 1/g' config.h
	sed -i 's/HAVE_TRUNCF 0/HAVE_TRUNCF 1/g' config.h
 

*上面的选项都是可以变化的，具体的配置需要我们根据具体的需求来定,其中每一个编译选项，我们都可以在FFmpeg源码的根目录下configure脚本文件中找到*

###编写Android.mk
[这里](/media/files/2013/08/29/Android.mk)有一个之前我用过的写好的，这个是针对ffmpeg0.9版本。

不同版本的ffmpeg内部的文件可能不一致，但是一般不会很多，最快的办法就是直接去用我提供的这个Android.mk编译，当提示找不到文件的时候，我们去在Android.mk中进行相应的增加和修改就可以了。

###编译
1. 首先执行上面的config.sh脚本，这个脚本会生成config.h文件，会对ffmpeg编译选项，使用的编译器进行配置;

    ./config.sh

2. 将上面写好的Android.mk放在FFmpeg源码根目录中，然后mm编译;
3. 过一段时间ffmpeg编译完毕，我们就能看到我们期望得到的动态库/静态库/bin文件等。

###后话，TODO
1. 细心的读者可能注意到上面的config.sh并没有指定gcc编译器，但是这样确实是可以编译通过跑起来的，这里我只是猜测，当前系统的编译器在lunch环境配置的时候已经指定了，mm脚本还没看过，猜测里面已经可以得到具体的gcc版本了。

2. 针对不同平台的编译选项优化，一直还没时间看，这里加个**TODO:**，以后要加进来。

