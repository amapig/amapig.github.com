---
title: '白话FFmpeg--（二）FFmpeg介绍'
layout: post
tags:
    - FFmpeg
---

###FFmpeg简介
FFmpeg是一个集录制、转换、音/视频编码解码功能为一体的完整的开源解决方案。FFmpeg的
开发是基于Linux操作系统，但是可以在大多数操作系统中编译和使用。FFmpeg支持MPEG、
DivX、MPEG4、AC3、DV、FLV等40多种编码，AVI、MPEG、OGG、Matroska、ASF等90多种解码.

FFmpeg主目录下主要有libavcodec、libavformat和libavutil等子目录。其中libavcodec用于存放各个encode/decode模块，libavformat用于存放muxer/demuxer模块，libavutil用于存放内存操作等辅助性模块。

###ubuntu下FFmpeg的安装和使用
ubuntu可以直接终端执行：

    sudo apt-get install ffmpeg

具体怎么使用，推荐看官网的[FFmpeg Documents](http://ffmpeg.org/documentation.html),里面能够找到针对每个模块的详细的使用方法。

###FFmpeg支持的编解码格式和容器格式

执行命令: 

    ffmpeg -formats

可以看到当前版本的ffmpeg支持的所有编码格式，解码格式以及容器格式。

###FFmpeg License。
FFmpeg代码中既有GPL协议的部分，也有LGPL协议，默认情况下FFmpeg是没有打开GPL协议的，如果我们需要使用GPL协议相关部分的code(比如：x264)，必须在config中显式的打开GPL选项。

*关于GPL和LGPL的协议，不了解的可以去[这里](http://www.gnu.org/licenses/licenses.html)看一下。*

###谁在用？

TCPMP, VLC, MPlayer等开源播放器都用到了FFmpeg。

暴风影音,qq影音，kmplayer也用到了FFmpeg，但是因为没有遵循它的license，被FFmpeg列在了[耻辱榜](http://www.ffmpeg.org/shame.html)上面。