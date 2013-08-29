---
title: '白话FFmpeg--（三）FFmpeg架构分析'
layout: post
tags:
    - FFmpeg
---

![ffmpeg-logo](/media/files/2013/08/29/ffmpeg-logo.png)

##视频文件播放流程
以AVC+AAC的matroska(mkv)文件为例：

####会经过如下几步：
1. 解析mkv容器格式，得到两条压缩的媒体流，也就是AVC视频流和AAC音频流;
2. 将AVC视频流和AAC音频流传给对应的Decoder进行解码;
3. 将解码之后的视频流送给render进行显示，音频流送给audio进行播放等;

基本的流程就是这样，FFmpeg自己的demo播放器FFplay也是这样的，涉及到具体的每个播放器在设计的时候的stack，就不是这里讨论的重点了。

FFmpeg源码中包含了上述步骤中的所有模块，它用来解析的代码在libavformat中，具体的解析交给对应文件格式的解析器，FFmpeg中将解析器称为：**muxer**。用来解码的代码在libavcodec中，具体的解码交给各自的解码器来实现，FFmpeg中将解码器称为：**decoder**。

###muxer/demuxer与encoder/decoder基本介绍
muxer/demuxer和encoder/decoder在FFmpeg中的实现代码里，有许多相同的地方，而二者最
大的差别是muxer和demuxer分别是不同的结构AVOutputFormat与AVInputFormat，而encoder
和decoder都是用的AVCodec结构。
 
muxer/demuxer和encoder/decoder在FFmpeg中相同的地方有：

1. 二者都是在main()开始的av_register_all()函数内初始化的
2. 二者都是以链表的形式保存在全局变量中的
        muxer/demuxer是分别保存在全局变量AVOutputFormat *first_oformat与
        AVInputFormat *first_iformat中的。
        encoder/decoder都是保存在全局变量AVCodec *first_avcodec中的。
3. 二者都用函数指针的方式作为开放的公共接口
    
demuxer开放的接口有：


    int (*read_probe)(AVProbeData *);
    int (*read_header)(struct AVFormatContext *, AVFormatParameters *ap);
    int (*read_packet)(struct AVFormatContext *, AVPacket *pkt);
    int (*read_close)(struct AVFormatContext *);
    int (*read_seek)(struct AVFormatContext *, int stream_index, int64_t timestamp, int flags);


muxer开放的接口有：


    int (*write_header)(struct AVFormatContext *);
    int (*write_packet)(struct AVFormatContext *, AVPacket *pkt);
    int (*write_trailer)(struct AVFormatContext *);

encoder/decoder的接口是一样的，只不过二者分别只实现encoder和decoder函数：


    int (*init)(AVCodecContext *);
    int (*encode)(AVCodecContext *, uint8_t *buf, int buf_size, void *data);
    int (*close)(AVCodecContext *);
    int (*decode)(AVCodecContext *, void *outdata, int *outdata_size, uint8_t *buf, int buf_size);

###muxer/demuxer匹配
1. 在libavformat\allformats.c文件的av_register_all(void)函数中，通过执行
   *REGISTER_MUXDEMUX(MATROSKA, matroska);*

    将支持matroska格式的ff_matroska_muxer与ff_matroska_demuxer变量分别注册到全局变量first_oformat与first_iformat链表的最后位置。
其中ff_matroska_demuxer在libavformat\matroskadec.c中定义如下:
这里面定义了解析文件需要的接口，初始化了AVOutputFormat结构体。


    	AVInputFormat ff_matroska_demuxer = {
        	   .name           = "matroska,webm",
            .long_name      = NULL_IF_CONFIG_SMALL("Matroska / WebM"),
            .priv_data_size = sizeof(MatroskaDemuxContext),
            .read_probe     = matroska_probe,
            .read_header    = matroska_read_header,
            .read_packet    = matroska_read_packet,
            .read_close     = matroska_read_close,
            .read_seek      = matroska_read_seek,
        };

2. 不是所有的格式都同时支持编码解码，ffmpeg提供了三种不同的注册方式：

    	#define REGISTER_MUXER(X, x)                                            
    	#define REGISTER_DEMUXER(X, x)                                          
    	#define REGISTER_MUXDEMUX(X, x) REGISTER_MUXER(X, x); sREGISTER_DEMUXER(X, x)


3. demuxer的匹配

    FFmpeg怎么确认用哪个demuxer来解析当前文件呢？它依靠什么来判断的呢？

