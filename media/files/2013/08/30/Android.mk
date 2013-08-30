LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
OPENCV_CAMERA_MODULES:=on
OPENCV_INSTALL_MODULES:=on

#OPENCV_LIB_TYPE:=STATIC

include /home/b375/opencv/OpenCV-2.4.3.2-android-sdk/sdk/native/jni/OpenCV.mk

#LOCAL_C_FLAGS := -D_STLP_NO_EXCEPTIONS -DOS_ANDROID -D_STLP_USE_SIMPLE_NODE_ALLOC
LOCAL_ALLOW_UNDEFINED_SYMBOLS := true

ANDROID_SOURCE:=/home/qiang/android/mainline
ANDROID_LIBS:=/home/qiang/android/mainline/out/target/product/redhookbay/system/lib
#ANDROID_STATICLIBS:=/home/b375/VideoSumm/mmvideo/appDemo/NativecvEditor_forNDK/jni/fflib

LOCAL_C_INCLUDES += /home/b375/android-ndk-r8d/sources/cxx-stl/stlport/stlport \
                $(LOCAL_PATH)/ffmpeg \
                $(ANDROID_SOURCE)/frameworks/av/include \
                $(ANDROID_SOURCE)/frameworks/native/include/media/openmax \
                $(ANDROID_SOURCE)/frameworks/av/media/libstagefright \
                $(ANDROID_SOURCE)/frameworks/av/include/media/stagefright \
                $(ANDROID_SOURCE)/frameworks/native/include \
                $(ANDROID_SOURCE)/frameworks/base/include/utils \
                $(ANDROID_SOURCE)/frameworks/base/include \
                $(ANDROID_SOURCE)/system/core/include \
                $(ANDROID_SOURCE)/frameworks/base/core/jni \
                $(ANDROID_SOURCE)/frameworks/base/native/include \
                $(ANDROID_SOURCE)/frameworks/base/include/gui \
                $(ANDROID_SOURCE)/hardware/libhardware/include \
                /home/b375/android-ndk-r8d/sources/cxx-stl/gnu-libstdc++/4.4.3/include  \
                /home/b375/android-ndk-r8d/sources/cxx-stl/gnu-libstdc++/4.4.3/libs/x86/include

LOCAL_MODULE    := native_cveditorscore
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := jni_part.cpp motionTracking.cpp motionTracking.h faceTracking.h videoScoring.h videoScoring.cpp faceTracking.cpp audioScoring.cpp \
    ffmpeg/ffmpeg_vs.c \
    ffmpeg/cmdutils_vs.c \
    ffmpeg/libavcodec/libstagefright.cpp

LOCAL_LDLIBS +=  -llog -ldl -lz \
        $(ANDROID_LIBS)/libstagefright.so \
        $(ANDROID_LIBS)/libutils.so \
        $(ANDROID_LIBS)/libcutils.so \
        $(ANDROID_LIBS)/libc.so \
        $(ANDROID_LIBS)/libmedia.so \
        $(ANDROID_LIBS)/libandroid_runtime.so \
        $(ANDROID_LIBS)/libgui.so \
        $(ANDROID_LIBS)/libmedia_jni.so \
        $(ANDROID_LIBS)/libskia.so \
        $(ANDROID_LIBS)/libui.so \
        $(ANDROID_LIBS)/libbinder.so \
        $(ANDROID_LIBS)/libnativehelper.so \
        $(LOCAL_PATH)/fflib/libavformat.a \
        $(LOCAL_PATH)/fflib/libavfilter.a \
        $(LOCAL_PATH)/fflib/libavcodec.a \
        $(LOCAL_PATH)/fflib/libavresample.a \
        $(LOCAL_PATH)/fflib/libavutil.a \
        $(LOCAL_PATH)/fflib/libswresample.a \
        $(LOCAL_PATH)/fflib/libswscale.a \

LOCAL_LDLIBS += -fuse-ld=bfd

#APP_CPPFLAGS += -fexceptions

include $(BUILD_SHARED_LIBRARY)
#include $(BUILD_EXECUTABLE)
