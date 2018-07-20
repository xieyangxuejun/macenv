# 目录

- [实战编解码](#实战编解码)
- [FFmpeg命令行](#FFmpeg命令行)

## FFmpeg命令行

- 压缩

```
//设置帧率
-r 30
-vf fps=fps=25 //修改帧率
//设置比特率 Bitate
-b 1.5M  //这里必须是大写
-b:v  or -b:a //指定音视频
//CBR设置,数值相同
-b 0.5M -minrate 0.5M -maxrate 0.5M -bufsize 1M
//文件大小不超过
-fs 10M  //大写
```



- 推流

```shell
ffmpeg -i rtmp://live.hkstv.hk.lxdns.com/live/hks -c:a copy -c:v copy -f flv rtmp://localhost:1935/live/home
```

- 

### 编译

- configure

```Shell
SLIBNAME_WITH_MAJOR='$(SLIBNAME).$(LIBMAJOR)'  
LIB_INSTALL_EXTRA_CMD='$$(RANLIB)"$(LIBDIR)/$(LIBNAME)"'  
SLIB_INSTALL_NAME='$(SLIBNAME_WITH_VERSION)'  
SLIB_INSTALL_LINKS='$(SLIBNAME_WITH_MAJOR)$(SLIBNAME)'
```

替换

```Shell
SLIBNAME_WITH_MAJOR='$(SLIBPREF)$(FULLNAME)-$(LIBMAJOR)$(SLIBSUF)'  
LIB_INSTALL_EXTRA_CMD='$$(RANLIB)"$(LIBDIR)/$(LIBNAME)"'  
SLIB_INSTALL_NAME='$(SLIBNAME_WITH_MAJOR)'  
SLIB_INSTALL_LINKS='$(SLIBNAME)'
```

### 常见编译问题

> 生成前期文件

```shell
./configure --enable-shared --disable-yasm --prefix=/usr/local/ffmpeg
//结果
WARNING: The --disable-yasm option is only provided for compatibility and will be removed in the future. Use --enable-x86asm / --disable-x86asm instead.
```

>  C compiler test failed.

- "-Bstatic" option instead of "-static" solved the issue

> 64位linux提示gnu/stubs-32.h,
>
> /usr/include/gnu/stubs-32.h ,64位
>
> /usr/include/features.h:No such file or directory的解决方法

```Shell
yum -y install glibc-devel gcc-multilib glibc-devel.i686 libstdc++-devel.i686
```

> 编译3.4.2的时候

```
// # include <linux/perf_event.h>报错 
//如要将platform改成21
```



###常见命令

**常用参数说明：**

**主要参数：**
-i 设定输入流
-f 设定输出格式
-ss 开始时间
**视频参数：**
-b 设定视频流量，默认为200Kbit/s
-r 设定帧速率，默认为25
-s 设定画面的宽与高
-aspect 设定画面的比例
-vn 不处理视频
-vcodec 设定视频编解码器，未设定时则使用与输入流相同的编解码器
**音频参数：**
-ar 设定采样率
-ac 设定声音的Channel数
-acodec 设定声音编解码器，未设定时则使用与输入流相同的编解码器
-an 不处理音频

# 重要结构体

- AVFormatContext：统领全局的基本结构体。主要用于处理封装格式（FLV/MKV/RMVB等）
- AVIOContext：输入输出对应的结构体，用于输入输出（读写文件，RTMP协议等）。
- AVStream，AVCodecContext：视音频流对应的结构体，用于视音频编解码。
- AVPacket：存储压缩数据（视频对应H.264等码流数据，音频对应AAC/MP3等码流数据）—>解码前的数据
- AVFrame：存储非压缩的数据（视频对应RGB/YUV像素数据，音频对应PCM采样数据） —>解码后的数据

# 重要结构体分析

1. AVFormatContext 
   iformat:输入视频的AVInputFormat 
   nb_streams :输入视频的AVStream 个数 
   streams :输入视频的AVStream []数组 
   duration :输入视频的时长(以微秒为单位) 
   bit_rate :输入视频的码率
2. AVInputFormat 
   name:封装格式名称 
   long_name:封装格式的长名称 
   extensions:封装格式的扩展名 
   id:封装格式ID 
   一些封装格式处理的接口函数
3. AVStream 
   id:序号 
   codec:该流对应的AVCodecContext  time_base:该流的时基 
   r_frame_rate:该流的帧率
4. AVCodecContext 
   codec:编解码器的AVCodec 
   width, height:图像的宽高(只针对视频)  pix_fmt:像素格式(只针对视频) 
   sample_rate:采样率(只针对音频) 
   channels:声道数(只针对音频) 
   sample_fmt:采样格式(只针对音频)
5. AVCodec 
   name:编解码器名称 
   long_name:编解码器长名称  type:编解码器类型 
   id:编解码器ID 
   一些编解码的接口函数
6. AVPacket 
   pts:显示时间戳 
   dts :解码时间戳 
   data :压缩编码数据 
   size :压缩编码数据大小 
   stream_index :所属的AVStream
7. AVFrame 
   data:解码后的图像像素数据(音频采样数据)。 
   linesize:对视频来说是图像中一行像素的大小;对音频来说是整个音 频帧的大小。 
   width, height:图像的宽高(只针对视频)。 
   key_frame:是否为关键帧(只针对视频) 。 
   pict_type:帧类型(只针对视频) 。例如I，P，B。

# 安装插件说明

ffmpeg作为一个多媒体框架和平台，最大的优势就在于可以很灵活地支持多种编解码和其他特性，只要第三方外部库支撑都可以做到。本次安装下列第三包依赖包：

- faac：全称是Free Advanced Audio Coder，是MPEG-4和MPEG-2 AAC的一款常用的开源编解码器；
- lame：一款常见的mp3的开源编解码器；
- libass：先说一下ASS/SSA，其全称是Advanced Substation Alpha/Substation Alpha，是一种功能极为强大的字幕格式，主要用在视频文件里显示字幕。而libASS是一个轻量级的对ASS/SSA格式字幕进行渲染的函数库，使用C编写,效率非常高；
- libdc1394：这是面向高级语言编程接口的一个库，主要提供了对符合IEEE 1394规范的数码摄录设备的一组操作接口。符合1395规范的数码相机标准的全称是1394-based Digital Camera Specifications，简称为IIDC或DCAM。安装dc1394需要先安装raw1394；
- libfreetype2：freetype是一个用C语言实现的一个字体光栅化库，它可以用来将字符栅格化并映射成位图以及提供其他字体相关业务的支持。freetype提供了一个简单、易用并统一的接口来访问字体文件的内容。freetype不仅被自由桌面系统软件所使用，同时它也是现代视频游戏广泛使用的栅格化引擎；
- libvorbis：这个库主要用于处理ogg格式的音频文件，而ogg全称是ogg vorbis，一种类似mp3的音频压缩格式。不同于mp3的是ogg完全免费、开放和没有专利限制的。ogg文件格式可以不断地进行大小和音质的改良，而不影响旧有的编码器或播放器，主要由Xiph.org基金会开发；
- libtheora：theora也是Xiph.org基金会开发，是一种有损的影像压缩格式；
- openssl：这个就不多说了，很多安全框架的基础；
- rtmpdump：一个开源的rtmp格式的流媒体库，RTMP(Real Time Messaging Protocol)是Adobe Systems公司为它自家的flash播放器和服务器之间音频、视频和数据传输开发的一种开放的传输协议；
- speex：speex是一套主要针对语音的开源免费、无专利保护的音频压缩格式，致力于通过提供一个可以替代高性能语音编解码来降低语音应用输入门槛。相对于其它编解码器，speex非常适合网络应用，因为它专为2-44kpbs语音码流所设计，所以在网络应用上有着自己独特的优势；
- twolame：一个开源的mp2格式的编解码库;
- vo-aacenc：AAC格式的常用的音频编码器;
- xvidcore：是一个开放源代码的MPEG-4视频编解码器；
- x264：目前最流行，最常见的H.264视频格式的一个开源的编解码器；
- Yasm:  一个跨平台、支持多种目标文件格式的汇编编译器。他重写了停滞的Nasm项目。并支持Gas（GNU assembler）语法和AMD64（EM64T）架构。源代码在三条款BSD等授权下发放。另一个免费使用的汇编编译器Fasm也支持AMD64（EM64T），但支持IA-64架构的只有Gas和Windows Server 2003 SP1 DDK中的MASM 8.0。

# FFmpeg解码函数

1. av_register_all():注册所有组件。
2. avformat_open_input():打开输入视频文件。
3. avformat_find_stream_info():获取视频文件信息。
4. avcodec_find_decoder():查找解码器。
5. avcodec_open2():打开解码器。
6. av_read_frame():从输入文件读取一帧压缩数据。
7. avcodec_decode_video2():解码一帧压缩数据。
8. avcodec_close():关闭解码器。
9. avformat_close_input():关闭输入视频文

```
AVCodecContext结构体被AVCodecParameters替换

```

# 音频相关计算

```
A sample = 4 bytes
ms = samples * 1000 / samplerate.
samples = ms * samplerate / 1000.
samplerate = samples * 1000 / ms.
bytes = samples * bits * channels / 8.
samples = bytes * 8 / bits / channels.
```



### Mask Encoding

```
ffmpeg -y -i input.mp4 -loop 1 -i mask_with_alpha.png -filter_complex "[1:v]alphaextract[alf];[0:v][alf]alphamerge" -c:v qtrle -an output.mov
```

# Mac配置ffmpeg

- 安装homebrew

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

- 安装ffmpeg

```
brew install ffmpeg –with-fdk-aac –with-ffplay –with-freetype –with-libass –with-libquvi –with-libvorbis –with-libvpx –with-opus –with-x265
```

如果还未安装以上依赖

```
brew install automake fdk-aac git lam libass libtool libvorbis libvpx \ opus sdl shtool texi2html theora wget x264 xvid yasm
```



###2. 基本安装方法

如果不需要安装额外的库文件（比如x264, vpx等），直接进行编译即可，也不需要额外的配置。

####2.1 下载源代码

```
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg1
```

这个就不多说了，随你怎么下吧

####2.2 编译

```
./configure; make && sudo make install1
```

PS：有一点需要说明的是这种方法编译后是没有ffplay的。

####编译Pkg-config

（1）下载源代码 
<https://pkg-config.freedesktop.org/releases/>

（2） Compile

```
GLIB_CFLAGS="-I/usr/local/include/glib-2.0 -I/usr/local/lib/glib-2.0/include" GLIB_LIBS="-lglib-2.0 -lgio-2.0" ./configure --with-pc-path="/usr/X11/lib/pkgconfig:/usr/X11/share/pkgconfig:/usr/lib/pkgconfig:/usr/local/lib/pkgconfig"1
```

###3.2 Yasm

Yasm是C汇编优化的东西，能够大幅提高ffmpeg的执行效率。 
（1）下载源码 
<http://yasm.tortall.net/Download.html>

（2）编译

```
./configure --enable-python; make && sudo make install
```

PS：这个直接Homebrew安装好了

###3.3 x264

```
sudo git clone git://git.videolan.org/x264.git
cd x264
sudo ./configure --enable-shared --prefix=/usr/local
sudo make
sudo make install
cd ..123456
```

ffmpeg对应编译参数：

```
--enable-gpl --enable-libx264
```

###3.4 libvpx

这个就是Google推出VP8，VP9编码

```
sudo wget http://webm.googlecode.com/files/libvpx-v0.9.7-p1.tar.bz2
sudo tar xvjf libvpx-v0.9.7-p1.tar.bz2
cd libvpx-v0.9.7-p1
sudo ./configure --enable-shared --prefix=/usr/local
sudo make
sudo make install
cd ..1234567
```

ffmpeg对应编译参数

```
--enable-libvpx
```

PS：这个直接Homebrew安装吧

```
brew install libvpx
```

###3.5 其它

####x264

```
# wget "http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.xz"
# tar xvf nasm-2.13.01.tar.xz
# cd nasm-2.13.01
# ./configure
# make&make install
```



####x265

H.265 编码器。

```
--enable-gpl --enable-libx265
```

####fdk-aac

AAC 音频编码器

```
 --enable-libfdk-aac
```

有个问题:

> libfdk_aac is incompatible with the gpl and --enable-nonfree is not specified.
>
> A:意思就是只要加--enable-nonfree不需--enable-gpl

####libvorbis

Vorbis 音频编码器 .依赖于libogg.

```
--enable-libvorbis
```

libopus 
Opus 音频编码器.

```
--enable-libopus
```

LAME 
MP3编码器

```
 --enable-libmp3lame
```

####libass

ASS字母渲染器

```
 --enable-libass
```

###3.6 ffmpeg完整编译命令实例

（1）config 
设置prefix = ./build，编译到当前build目录下

```shell
mkdir build
./configure  --prefix=./build --enable-gpl --enable-nonfree --enable-libass --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libxvid
```

### FFmpeg合并一个SO

```
#!/bin/bash
export TMPDIR=/Users/hubin/Desktop/ffmpeg-3.0/ffmpegtemp #这句很重要，不然会报错 unable to create temporary file in

# NDK的路径，根据自己的安装位置进行设置
NDK=~/Applications/android-sdk/ndk-bundle

# 编译针对的平台，可以根据自己的需求进行设置
# 这里选择最低支持android-14, arm架构，生成的so库是放在
# libs/armeabi文件夹下的，若针对x86架构，要选择arch-x86
PLATFORM=$NDK/platforms/android-14/arch-arm

# 工具链的路径，根据编译的平台不同而不同
# arm-linux-androideabi-4.9与上面设置的PLATFORM对应，4.9为工具的版本号，
# 根据自己安装的NDK版本来确定，一般使用最新的版本
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64

function build_one
{
./configure \
    --prefix=$PREFIX \
    --target-os=linux \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --arch=arm \
    --sysroot=$PLATFORM \
    --extra-cflags="-I$PLATFORM/usr/include" \
    --cc=$TOOLCHAIN/bin/arm-linux-androideabi-gcc \
    --nm=$TOOLCHAIN/bin/arm-linux-androideabi-nm \
    --disable-shared \
    --enable-runtime-cpudetect \
    --enable-gpl \
    --enable-small \
    --enable-cross-compile \
    --disable-debug \
    --enable-static \
    --disable-doc \
    --disable-asm \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-postproc \
    --disable-avdevice \
    --disable-symver \
    --disable-stripping \

$ADDITIONAL_CONFIGURE_FLAG
sed -i '' 's/HAVE_LRINT 0/HAVE_LRINT 1/g' config.h
sed -i '' 's/HAVE_LRINTF 0/HAVE_LRINTF 1/g' config.h
sed -i '' 's/HAVE_ROUND 0/HAVE_ROUND 1/g' config.h
sed -i '' 's/HAVE_ROUNDF 0/HAVE_ROUNDF 1/g' config.h
sed -i '' 's/HAVE_TRUNC 0/HAVE_TRUNC 1/g' config.h
sed -i '' 's/HAVE_TRUNCF 0/HAVE_TRUNCF 1/g' config.h
sed -i '' 's/HAVE_CBRT 0/HAVE_CBRT 1/g' config.h
sed -i '' 's/HAVE_RINT 0/HAVE_RINT 1/g' config.h

make clean
make -j4
make install

$TOOLCHAIN/bin/arm-linux-androideabi-ld \
-rpath-link=$PLATFORM/usr/lib \
-L$PLATFORM/usr/lib \
-L$PREFIX/lib \
-soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
$PREFIX/libffmpeg.so \
    libavcodec/libavcodec.a \
    libavfilter/libavfilter.a \
    libswresample/libswresample.a \
    libavformat/libavformat.a \
    libavutil/libavutil.a \
    libswscale/libswscale.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
    $TOOLCHAIN/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a \

}

# arm v7vfp
CPU=armv7-a
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
PREFIX=./android/$CPU-vfp
ADDITIONAL_CONFIGURE_FLAG=
build_one

# CPU=armv
# PREFIX=$(pwd)/android/$CPU
# ADDI_CFLAGS="-marm"
# build_one

#arm v6
#CPU=armv6
#OPTIMIZE_CFLAGS="-marm -march=$CPU"
#PREFIX=./android/$CPU
#ADDITIONAL_CONFIGURE_FLAG=
#build_one

#arm v7vfpv3
# CPU=armv7-a
# OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=$CPU "
# PREFIX=./android/$CPU
# ADDITIONAL_CONFIGURE_FLAG=
# build_one

#arm v7n
#CPU=armv7-a
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"
#PREFIX=./android/$CPU
#ADDITIONAL_CONFIGURE_FLAG=--enable-neon
#build_one

#arm v6+vfp
#CPU=armv6
#OPTIMIZE_CFLAGS="-DCMP_HAVE_VFP -mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU"
#PREFIX=./android/${CPU}_vfp
#ADDITIONAL_CONFIGURE_FLAG=
#build_one
```

### 特效视频处理

1. 利用MediaExtractor获取Mp4的音轨和视轨，获取音频视频的MediaFormat.
2. 根据音视频信息，创建视频解码器，视频编码器，音频暂时不处理就不创建编解码器了。**其中视频解码器的Surface是通过先创建一个SurfaceTexture，然后将这个SurfaceTexture作为参数创建的，这样的话，视频流就可以通过这个SurfaceTexture提供给OpenGL环境作为输出。视频编码器的Surface可直接调用createInputSurface()方法创建，这个Surface后续传递给OpenGL环境作为输出**
3. 创建MediaMuxer，用于后面合成处理后的视频和音频。
4. 创建OpenGL环境，用于处理视频图像，这个OpenGL环境由EGL创建，EGLSurface为WindowSurface，并以编码器创建的Surface作为参数。
5. MediaExtractor读取原始Mp4中的视频流，交由解码器解码到Surface上。
6. SurfaceTexture监听有视频帧时，通知OpenGL线程工作，处理视频图像，并渲染。
7. OpenGL线程每次渲染完毕，通知编码线程进行编码，编码后的数据通过MediaMuxer混合。
8. 视频流处理完毕后，利用MediaExtractor读取音频流，并利用MediaMuxer混合到新的视频文件中。
9. 处理完毕后调用MediaMuxer的stop方法，处理后的视频就生成成功了。




## 实战编解码

```shell
//伪代码
开始—->
av_register_all();
// Open video file
avformat_open_input()；
// Retrieve stream information
av_find_stream_info();
// Find the first video stream
// Get a pointer to the codec context for the video stream
av_find_best_stream();
// Find the decoder for the video stream
avcodec_find_decoder();
// Allocate video frame
while(av_read_frame()) {
    获取到packet—->
    avcodec_send_packet();
    avcodec_receive_frame();
    获取到frame
}
//free
av_free(buffer);
    av_free(pFrameRGBA);
    // Free the YUV frame
    av_free(pFrame);
    // Close the codecs
    avcodec_close(pCodecCtx);
    // Close the video file
    avformat_close_input(&pFormatCtx);
```



## 4.0编译问题

- 源文件没有包含

  - cannot locate symbol "ff_a64multi_encoder"

    ​


- 方法不能重载 multidefine

```shell
//新建libavutil/log2_tab.h...将方法写到头部...将其他的位置引入头部
//将libavformat/goloble.c下头部引入goloable.h
//新建libavutil/reverse.h ...将方法重写都头部....其他地方引入
```

- 可能会有警告, 忽略.

```
WARNING: arm-linux-androideabi-pkg-config not found, library detection may fail.
WARNING: using libx264 without pkg-config
```

- 链接失败

```
g++ mm.cpp -Wl,--unresolved-symbols=ignore-in-object-files

ignore-all
           Do not report any unresolved symbols.

report-all
           Report all unresolved symbols.  This is the default.

ignore-in-object-files
           Report unresolved symbols that are contained in shared
           libraries, but ignore them if they come from regular object
           files.

ignore-in-shared-libs
           Report unresolved symbols that come from regular object
           files, but ignore them if they come from shared libraries.  This
           can be useful when creating a dynamic binary and it is known
           that all the shared libraries that it should be referencing
           are included on the linker's command line.
```

- C++没有重载方法,需要更改#include file.c 获取 file.h

  需要在只有file.c文件下新建file.h文件

```
arm-linux-androideabi-ar: libavfilter/log2_tab.o: No such file or directory
make: *** [libavfilter/libavfilter.a] Error 1
make: *** Waiting for unfinished jobs....
```

- C compiler test failed.

> 在ffbuild查询的时候发现fdk-aac: no archive symbol table (run ranlib)

发现惊天大消息

> WARNING: make-standalone-toolchain.sh will be removed in r13. Please try make_standalone_toolchain.py now to make sure it works for your needs.

- 库未安装

java.lang.UnsatisfiedLinkError: dlopen failed: cannot locate symbol "ff_mjpeg_encoder" referenced by "/data/app/com.digizen.g2u-1/lib/arm/libffmpeg.so"...

- --enable-libass加了这个配置,找不到config-pkg

```
export PKG_CONFIG_PATH=/usr/local/fribidi/lib/pkgconfig:$PKG_CONFIG_PATH
```

- not char

error: libavcodec/sinewin_fixed_tablegen.o:1:1: invalid character



## 常用库安装

1.libfdk_aac官网下载**

(https://sourceforge.net/projects/opencore-amr/files/fdk-aac/)

**2.libmp3lame官网下载**

<https://sourceforge.net/projects/lame/files/lame/>

随便选择一个自己的版本下载即可

**3.libx264官网下载**

<https://www.videolan.org/developers/x264.html>

另外一个网址:<http://download.videolan.org/pub/videolan/x264/snapshots/>

## autoreconf 命令

必要参数  

-d 不删除临时文件 

-f 认为所有的文件都是过期的文件/强制执行 

-i 复制辅助文件 

-s 创建符号链接，而不是复制 

-m 当可用时，重新运行命令./configure 和 make 

-W 报告语法错误信息

### cmd

```java
int jxRun(int argc, char **argv) {
    av_log(NULL, AV_LOG_WARNING, " 命令开始");

    int i, ret;
    int64_t ti;
    init_dynload();

    register_exit(ffmpeg_cleanup);


    setvbuf(stderr, NULL, _IONBF, 0); /* win32 runtime needs this */

    av_log_set_flags(AV_LOG_SKIP_REPEATED);
    parse_loglevel(argc, argv, options);

    if (argc > 1 && !strcmp(argv[1], "-d")) {
        run_as_daemon = 1;
        av_log_set_callback(log_callback_null);
        argc--;
        argv++;
    }

    avcodec_register_all();
#if CONFIG_AVDEVICE
    avdevice_register_all();
#endif
    avfilter_register_all();
    av_register_all();
    avformat_network_init();

    av_log(NULL, AV_LOG_WARNING, " 注册完成编解码器");

    show_banner(argc, argv, options);

    /* parse options and open all input/output files */
    ret = ffmpeg_parse_options(argc, argv);
    if (ret < 0)
        exit_program(1);

    if (nb_output_files <= 0 && nb_input_files == 0) {
        show_usage();
        av_log(NULL, AV_LOG_WARNING, "Use -h to get full help or, even better, run 'man %s'\n",
               program_name);
        exit_program(1);
    }

    /* file converter / grab */
    if (nb_output_files <= 0) {
        av_log(NULL, AV_LOG_FATAL, "At least one output file must be specified\n");
        exit_program(1);
    }

//     if (nb_input_files == 0) {
//         av_log(NULL, AV_LOG_FATAL, "At least one input file must be specified\n");
//         exit_program(1);
//     }

    for (i = 0; i < nb_output_files; i++) {
        if (strcmp(output_files[i]->ctx->oformat->name, "rtp"))
            want_sdp = 0;
    }

    current_time = ti = getutime();
    if (transcode() < 0)
        exit_program(1);
    ti = getutime() - ti;
    if (do_benchmark) {
        av_log(NULL, AV_LOG_INFO, "bench: utime=%0.3fs\n", ti / 1000000.0);
    }
    av_log(NULL, AV_LOG_DEBUG, "%"PRIu64" frames successfully decoded, %"PRIu64" decoding errors\n",
           decode_error_stat[0], decode_error_stat[1]);
    if ((decode_error_stat[0] + decode_error_stat[1]) * max_error_rate < decode_error_stat[1])
        exit_program(69);

    exit_program(received_nb_signals ? 255 : main_return_code);

    nb_filtergraphs = 0;
    nb_input_streams = 0;
    nb_input_files = 0;
    progress_avio = NULL;


    input_streams = NULL;
    nb_input_streams = 0;
    input_files = NULL;
    nb_input_files = 0;

    output_streams = NULL;
    nb_output_streams = 0;
    output_files = NULL;
    nb_output_files = 0;

    return main_return_code;
}
```











