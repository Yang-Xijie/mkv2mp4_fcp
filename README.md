# README

This repository provides kinds of shell scrips to help you convert media that may be not well-supported on `macOS`. The most important one is `mkv_to_mp4.sh`, converting mkv files with HEVC/AVC and FLAC codec.

Author: Yang-Xijie <https://github.com/Yang-Xijie>

If you want to figure out how to use this script and how to create MAD with the best quality, check serial tutorials on [Bilibili](https://www.bilibili.com/video/BV1JA411A7FV) (Chinese).

- [README](#readme)
- [Convert BDrip(.mkv) to mp4(.mp4)](#convert-bdripmkv-to-mp4mp4)
  - [Background](#background)
  - [Function](#function)
  - [How to Use it](#how-to-use-it)
  - [Discussion](#discussion)
    - [ffmpeg and -vtag](#ffmpeg-and--vtag)
    - [modify the script if necessary](#modify-the-script-if-necessary)
    - [transcode in FCP to better your video editing experience](#transcode-in-fcp-to-better-your-video-editing-experience)
- [Other Scrips](#other-scrips)
  - [Convert BDMV(.m2ts) to mov](#convert-bdmvm2ts-to-mov)
    - [Function](#function-1)
  - [Convert FLAC(.flac) to ALAC(.m4a)](#convert-flacflac-to-alacm4a)
    - [Function](#function-2)
    - [Discussion](#discussion-1)
- [Note](#note)

# Convert BDrip(.mkv) to mp4(.mp4)

## Background

Sometimes we want to create our own MAD using great clips in some animation. We download the resources (often `BDrip` because it's rather smaller than `BDMV` and with great quality) from BT or PT sites or somewhere else. But these files have a container `mkv` (often with `HEVC` (video) and `FLAC` (audio) codec) which is unable to import into FCP (because mkv is not an official container format).

To convert `BDrip`, one way is to transcode it. However, to *extrat and re-package* them into a compatitable continer is **much more efficient** and **keep the original quality**. This script is to realize it.

## Function

Convert anime `BDrip` (with `mkv` container format, **track 0** `HEVC`, **track 1** `FLAC`) to `mp4` in order to make it importable in `FCP` without transcoding (just *extract and re-package*). (Note: also importable in `Compressor` so that you can further convert it to other codecs that are well-supported on `macOS` such as `Apple Prores`.)

## How to Use it

* (Once) Get the script `mkv_to_mp4.sh`: download the zip of this repo / clone this repo / open the script on GitHub and copy the content to a newly created text file and rename it
* (Once) Make the script executable: run command `chmod +x mkv_to_mp4.sh`.
* (Once) Install the required tools: run command `brew install mkvtoolnix ffmpeg mp4box`. ([brew](https://brew.sh), one of the best package managers for macOS, should be installed before. Run command `brew update` before installing new packages.)
* Change the shell working directory to the folder with mkv files: run command `cd <folder>`. Check the codec of mkv tracks -- this script only supports **track 0** `HEVC(h265)`, **track 1** `FLAC`. To convert mkv files with `AVC(h264)` codec, change all `h265` to `h264` in this script.)
* Copy the script to the current directory.
* Run the script: run command `./mkv_to_mp4.sh`.

## Discussion

### ffmpeg and -vtag

Theoretically command `ffmpeg -i <input>.mkv -vcodec copy -acodec alac <output>.mp4` works. But FCP cannot import the `<output>.mp4` for its restriction on the description of video codec. (check [StackExchange | Reason for -vtag](https://video.stackexchange.com/questions/26418/whats-special-about-apple-device-generated-hevc-files-that-apparently-x265-ca) and [Apple Developer Documentation | HLS Authoring Specification for Apple Devices | Video 1.10](https://developer.apple.com/documentation/http_live_streaming/hls_authoring_specification_for_apple_devices?language=objc) for more information). 

Moreover, if you use command `ffmpeg -i <input>.mkv -map 0:0 -map 0:1 -vcodec copy -acodec alac -vtag hvc1 "<output>.mov"`, the frame-rate goes wrong (from 23.98 to 23.81, CFR to VFR). (check [reddit | Framerate issue in fcp (23.98-23.81 FPS)](https://www.reddit.com/r/ffmpeg/comments/dm5z04/framerate_issue_in_fcp_23982381_fps/) for more information). That ffmpeg doesn't obey standard mp4 boxing might be the reason.

### modify the script if necessary

You should **make slight adjustment** in the script if your media has a codec different from `mkv format, track 0 HEVC, track 1 FLAC`.

### transcode in FCP to better your video editing experience

(after importing mp4 files into FCP) For editing in `FCP`, it's better to use `Apple Prores` to make rendering faster. Choose `proxy` in `FCP` if your `Mac` lacks performance, or transcode the media to `Apple Prores 422`.

**Notice** Import output files (`.mp4`) directly into `FCP` because they have the original quality. **Don't** transcode them using other apps which may decrease the quality. (converting to `Apple Prores 422 HQ / 422` just slightly decrease quality and it's convenient if you have a workflow with large storage. To learn more, check [Apple Prores White Paper](https://www.apple.com/final-cut-pro/docs/Apple_ProRes_White_Paper.pdf).)

# Other Scrips

Here are some other scripts that convert specific kinds of media.

## Convert BDMV(.m2ts) to mov

`BDMV` owns the best quality of anime. Convert them to mov in order to import them into `FCP` with the best quality.

### Function

Convert `BDMV` anime (with m2ts format, track 0 `H264/AVC`, track 1 `PCM`) to `mov` in order to make it importable in `FCP` without transcoding.

## Convert FLAC(.flac) to ALAC(.m4a)

`FLAC` is a codec for lossless audio. However, `FCP` or `Compressor` (and also `Music.app`) doesn't support that not-for-industry audio codec.

`ALAC` is a codec for lossless audio designed by `Apple`. So it has a great support in `macOS`.

### Function

The function of this script is to convert `FLAC` file (with a suffix `.flac`) to `ALAC` (with a suffix `.m4a`).

### Discussion

You may think command `ffmpeg -i song.flac -acodec alac song.m4a` or `ffmpeg -i song.flac song.m4a` is enough. But unfortunately sometimes it fails. Check [Stack Overflow](https://stackoverflow.com/questions/55429909/could-not-find-tag-for-codec-h264-in-stream-0-codec-ffmpeg-flac-to-alac-conver) for details.

# Note

* English is not my native language; please excuse typing errors. Suggestions on my expression is welcome!
* Any advice or discussion will be appreciated!
