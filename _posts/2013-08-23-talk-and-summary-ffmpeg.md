---
title: '白话FFmpeg--(一)开始'
layout: post
tags:
    - FFmpeg
---

![ffmpeg-logo](/media/files/2013/08/29/ffmpeg-logo.png)
###写在前面
从接触FFmpeg开始到现在，算起来有将近4年的时间了，4年说来惭愧，各种项目中一直断断续续的会用到FFmpeg，但是一直理解的也不是很深。

咱水平不高，写出来的东西也算不上教程，下面的几篇文章也无非就是把网上经常看到的很多资料和自己工作中遇到的一些问题，整合一下，本来可以省很多时间做这件事情，因为之前已经整理了几篇，但是硬盘挂掉让我的资料也彻底挂了。

这里提醒广大劳动人民，总结须谨慎，备份要实时（推荐：*dropbox + github* 爽歪歪）。

##FFmpeg基础：

* [FFmpeg介绍](http://amapig.github.io/2013/08/25/FFmpeg-basic-knowledge.html)
* [FFmpeg架构分析](http://amapig.github.io/2013/08/29/FFmpeg-architecture-analysis.html)
* FFmpeg的使用（推荐两篇文章）：
    1. [How to Write a Video Player in Less Than 1000 Lines](http://dranger.com/ffmpeg/)
    2. [Using libavformat and libavcodec](http://www.inb.uni-luebeck.de/~boehme/using_libavcodec.html)

##Android平台编译FFmpeg：

Android编译底层c/c++库一般有这样两种方式：

1. [自己编写Android.mk来编译FFmpeg(不推荐)](http://amapig.github.io/2013/08/29/write-an-android-mk-file-to-build-ffmpeg.html)

2. [利用NDK的交叉编译环境直接通过FFmpeg的MakeFile编译](http://amapig.github.io/2013/08/30/how-to-build-ffmpeg-for-android-with-ndk.html)

**另外，FFmpeg自己写了一套使用Android libstagefright硬件解码器的东西，在libavcodec/libstagefright.cpp这个文件中。默认情况下，这个文件是没有被编译到FFmpeg中的，需要打开相应的编译选项，**

    enable-libstagefright-h264

关于编译这个文件的文章，请看：

[FFmpeg enable libstagefrith_h264编译](http://amapig.github.io/2013/08/30/compile-libstagefright-cpp-in-ffmpeg.html)

FFmpeg编译过程中会遇到很多编译的问题，有的时候还需要修改源码，下面把我曾经遇到的编译问题归纳一下，可能不全，以后陆续补充，不过这里没有的话，多google几次肯定能够解决的：

 [编译FFmpeg遇到的问题汇总](/_posts/)

##移植FFmpeg到Android;

* [平台需求：将FFmpeg嵌入Android stagefright多媒体框架中](/_posts/)
* [软件需求：Android应用开发中怎么使用FFmpeg](/_posts/)

##推荐两个不错的FFmpeg的博客：

* [http://blog.csdn.net/tx3344](http://blog.csdn.net/tx3344)
* [http://xcshen.blog.51cto.com/2835389/d-1](http://xcshen.blog.51cto.com/2835389/d-1)







