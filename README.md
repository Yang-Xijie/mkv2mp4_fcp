# mkv2mp4_fcp
Convert BDrip(mkv) to mp4 to make it importable in FCP.

You could read the following contents also on [CSDN](https://blog.csdn.net/qq_45379253/article/details/109966910)
# 需求
> 系统：macOS Big Sur 11.0.1
> Permute 3：3.5.9 (build 2317)
> FCPX：10.5

笔者需要将下载好的BDrip（封装格式为mkv）转换为能够被FCP支持的视频格式。
这里“转换”有两种含义
* 将mkv封装格式文件中的视频（一般为HEVC）和音频（一般为FLAC）解码后重新转码为视频（AVC（即H.264）或HEVC（即H.265））和音频（AAC），导入FCPX使用
* 将mkv封装格式文件中的视频和音频提取出来，重新进行封装（比如封装格式mp4或mov），使其能够导入FCP

第一种方案可以由常见的视频格式转换软件完成，如macOS平台上的Permute 3就可以很容易的完成这件事情。但是这样就需要CPU与GPU进行运算，花费时间较长（约为原视频时间长度的1/6）
第二种方案至少我没找到合适的软件进行操作。经过将近两天的研究，我采用命令行进行提取和重新封装。这种方式不需要对视频解码转码，因此速度非常快，一个文件（1GB左右）可以在20s内完成转换。
**本文介绍的方法为第二种**
# 操作
新建如下shell脚本，命名为`convert.sh`
```shell
# /bin/zsh

# Functions: Convert anime(with mkv format, track 0 hevc, track 1 flac) to mp4 to make it importable to FCP without recoding .
# On macOS Big Sur 11.0.1. FCP version 10.5.
# You can use `brew install mkvtoolnix ffmpeg mp4box` to install all tools needed.
# You can use `mkvinfo "$anime"` to get details of mkv files.
# Read more here https://github.com/Yang-Xijie/mkv2mp4_fcp

turn=1 # counter, make name of intermidiate files short.
for anime in *.mkv; do
    echo "START $turn $anime"

    mkvextract tracks "$anime" 0:"$turn"".h265" 1:"$turn"".flac"
    # Firstly, extract tracks from mkv file.
    ffmpeg -i "$turn"".flac" -acodec alac "$turn"".m4a"
    # Secondly, for the audio, change FLAC(Free Lossless Audio Code) to ALAC(Apple Lossless Audio Code), which are both lossless. FLAC is not well compatible with FCP.
    mp4box -add "$turn"".h265" -add "$turn"".m4a" "${anime%.mkv}"".mp4"
    # Then use mp4box to put hevc and alac together in a mp4 format.
    rm "$turn"".h265" "$turn"".flac" "$turn"".m4a"
    # Finally, don't forget to delete intermidiate files.
    # If you want to move files to trash, `brew install trash` and then change "rm" to "trash".

    echo "DONE! ""$turn"
    echo "========================"
    let turn=$turn+1
done
```
该脚本中注释说明了每一步的作用。
将`convert.sh`移动到mkv文件所在的文件夹，打开终端`cd`到当前目录，使用命令`chmod a+x convert.sh`开启执行权限，后使用`./convert.sh`执行脚本。可以看到在较短的时间内mkv已经被转换为了mp4

## 注意
* 其中将FLAC用ffmpeg解码重编码为ALAC是因为笔者发现FCP不能很好的兼容FLAC。
* 该方法仅仅适用于mkv的tracks中0通道为HEVC且1通道为FLAC的BDrip（一般mkv都是这样）。如果格式不符，那么在使用时可能需要对代码进行修改。
* 对于剪辑来说，AVC和HEVC都不是很好的编码，只有像Apple Prores之类的逐帧编码才能让剪辑最高效。对比AVC和HEVC，剪辑HEVC对计算机的算力要求更高。如果你需要对素材进行复杂的剪辑，可以在FCP导入素材时对素材进行转码。