---
title: '白话FFmpeg--(五)利用NDK编译ffmpeg for android'
layout: post
tags:
    - FFmpeg
---
这种方式现在是网上最流行也最方便的方式，因为利用NDK我们只需要写一个针对FFmpeg的config.sh文件，然后交叉编译器仍然可以用FFmpeg源码中原来的Makefile来进行编译。

这里提供几个成熟可用的config.sh。

####1. 栗强他们在编译OpenCV中ffmpeg：
[FFmpeg-OpenCV-LQ.sh](media/files/2013/08/29/FFmpeg-OpenCV-LQ.sh)

####2. 网上VPlayer的作者写的，针对不同arm平台做了编译选项的优化：
[FFmpeg-Android-Vplayer.sh](/media/files/2013/08/29/FFmpeg-Android-vplayer.sh)

####3. android市场，最好的播放器MXplayer的作者，和VPlayer的作者写的方式差不多，不过多了针对x86平台的编译优化。
[FFmpeg-Android-MXplayer.sh](media/files/2013/08/29/FFmpeg-Android-MXplayer.sh)

####总之：
如果想写一个自己的config.sh，参照上面三个例子，然后对照FFmpeg源码中的configure文件，是不难的。