---
title: '白话FFmpeg--(七)平台需求：将FFmpeg嵌入Android stagefright多媒体框架中'
layout: post
tags:
    - FFmpeg
---

###平台需求
解释一下这里说的平台需求是什么意思，比如，我们之前给别人做方案，因为Android本身支持的视频格式非常少，编码器解码器格式也不多，这时候客户提出需求，想让我们支持某几种Android平台本身不支持的格式，这个时候在嵌入式领域，人们会想到FFmpeg，GStreamer，etc。

利用这些开源的多媒体解决方案，我们可以以相对简单多的方式来让我们的Android平台支持更多的容器格式和编码器解码器。

###Android平台多媒体框架
从Android2.2开始，Android多媒体框架开始采用stagefright，想对于OpenCore来说stagefright是一个轻量级的播放器框架，但是轻量级不代表不好，它的设计，它的可扩展性还是很值得学习的。

经过几个大版本的升级，Android4.1之后，stagefright框架中能够发现的bug已经比原来少了很多。

下面就介绍怎么将FFmpeg嵌入到stagefright这个多媒体框架中：

###为什么要将FFmpeg嵌入stagefright，而不是作为一个第三方的动态库直接通过jni供java调用呢？

这是因为在视频播放过程中，我们经常会播放高清的片源，而如果我们将FFmpeg作为第三方库来调用，实现视频播放的话，完全用的FFmpeg的软件解码器，解码效率很低而且高清片源会非常卡顿。那有什么好的解决方案吗？当然，那就是用平台当前的硬件解码器，为了能够非常完美的利用现有平台提供的硬件解码器，我们需要将FFmpeg嵌入到stagefright框架中，这种方式对于做平台来说，没有任何坏处，丰富了现有平台的容器格式，并且对于不支持的codec，还可以走FFmpeg的软件编解码器。如下面两张图对比：

![图片对比](media/files/2013/08/30/Android-ffmpeg.png)

从图中我们可以很清楚的看出，将FFmpeg嵌入到Stagefright之后，我们给当前平台带来了什么：

1. 当前平台支持的parser但是不支持的codec，将能够通过FFmpeg的软件解码器来解码;
2. 当前平台不支持的parser将能够通过FFmpeg的parser来解码;
3. 当前平台不支持的parser，但是支持的HWcodec，将能够通过FFMpeg parse,然后利用平台的HW decoder;

这样我们基本上可以播放FFmpeg能够提供给我们的所有的视频了。

###移植
嵌入之前，我假设读者对Android stagefright框架有基本的了解，对于数据流程有清晰的认识，然后，开始：

1. 模仿MatroskaExtractor.cpp文件，封装一个FFmpeg的FFmpegExtractor出		   来，Extractor解析当前平台不能解析的所有的文件。

2. 在DataSource中Sniff中注册我们的sniff方法，RegisterSniffer(SniffFF);

3. 在MediaExtractor.cpp中加入针对FFmpegExtractor的判断流程。

基本的就这么简单的三个地方，我们就把我们封装的FFmpegExtractor嵌入到了stagefirhgt中，关于具体的FFmpegExtractor应该怎么设计，怎么调用ffmpeg来进行封装，之后我会写一个demo放上来，大家参考一下，逻辑比较简单的。

###//TODO: