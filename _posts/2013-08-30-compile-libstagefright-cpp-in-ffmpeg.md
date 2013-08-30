---
title: '白话FFmpeg--(六)编译FFmpeg中libstagefright.cpp文件'
layout: post
tags:
    - FFmpeg
    - libstagefright
---

###libstagefright.cpp
为了能够使用Android平台的硬件解码器,FFmpeg加了这样一个文件libstagefright.cpp,这个文件具体做什么的呢？

1. 它通过直接和Android平台的OMXCodec打交道，来达到调用Android平台硬件解码器的作用。
这个文件的具体设计结构，稍后会另外整理一篇文章来介绍，这篇文章只针对，怎么编译libstagefright.cpp这个文件。

2. 它目前只是实现了Android平台H.264的硬件解码(经过本人测试，H.264和大部分MPEG4是可以正常硬件解码的)。

###尝试1 ： 直接执行FFmpeg官方提供的脚本
在FFmpeg源码根目录下找到这个脚本文件：tools/build_stagefright，这个脚本文件就是FFmpeg官网提供的，用来将这个文件编译进FFmpeg库的。
将脚本里面对应的NDK路径，android-source，android-lib都指定好之后，用这个脚本文件目前还是**没有编译成功**。

###尝试2 ： 将FFmpeg官方提供的脚本build_stagefright中的内容提取出来
将FFmpeg中针对libstagefright.cpp的编译脚本build_stagefright中的编译内容提取出来，放到前面我们提到的config.sh文件中，然后通过config.sh
来配置编译选项，达到编译libstagefright.cpp的目的，但是目前这种方式也**没有成功**。

###尝试3 ： 从FFmpeg中取出libstagefright.cpp文件单独编译
FFmpeg支持使用者自己开发编码器解码器，然后作为plugin的形式注册到FFmpeg，第三种尝试的思路就是，我单独把libstagefright.cpp文件拿出来，把它和我自己的代码一起编译，生成一个动态库，然后在我调用FFmpeg注册所有的编码器解码器的时候，把我提取出来的这个libstagefright.cpp作为一个第三方的解码器插件注册到ffmpeg中去，之后我们parse和decode数据的时候，完全可以把咱们自己注册的这个解码器作为FFmpeg自己的解码器来用了。

非常幸运的是，第三种尝试方案，居然**成功了**.

这里贴上针对x86平台的编译成功的[Android.mk](/media/files/2013/08/30/Android.mk)。


针对上面1，2和3的尝试，其实原理都是一样的，都是将Android源码中存在而NDK中又没有的头文件，动态库加入到编译配置文件中，1和2虽然没有成功，也是编译过程中遇到了太多的麻烦，但是理论上也是绝对可行的，以后有时间，我回过头来再尝试1和2，跟大家分享。
尝试3中的方法绝对是可以让你最快的将libstagefright.cpp用起来的。
