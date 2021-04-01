# README
This repo provides kinds of shell scrips to help you convert media that may be not well supported on `macOS`.

Author: Yang-Xijie <https://github.com/Yang-Xijie>

# Convert BDrip(.mkv) to mp4(.mp4)
## Function
Convert anime `BDrip` (with `mkv` format, track 0 `HEVC`, track 1 `FLAC`) to `mp4` in order to make it importable in `FCP` without recoding (just extract and re-package). (Note: also be importable in `Compressor` so that you can further convert it to other codecs which are well supported on `macOS` like `Apple Prores`.)

## Background
Sometimes we want to make MAD using anime. We download the resources (often `BDrip` because it's rather small than `BDMV` but with great quality) from BT or PT sites or somewhere. But these files have a container `.mkv` with `HEVC` (video) and `FLAC` (audio) codec.

To convert `BDrip`, one way is to transcode it. However, to *extrat and re-package* them into a compatitable continer is **much more efficient** and **keep the original quality**. This script is to realize it.

## Operation
Clone this repo or copy the content in `mkv_to_mp4.sh`. Put the `mkv_to_mp4.sh` in an appropriate place (notice that the script converts all mkv files inside and under the path it exists). Then use `./mkv_to_mp4.sh` to run the script.

## Note 
You may need to use command `chmod a+x mkv_to_mp4.sh` to make script executable.

Theoretically command `ffmpeg -i <mkv_file> -vcodec copy -acodec alac <output>.mp4` works. But sometimes FCP cannot import the `<output_file>` for its restriction of HEVC codec. Even if you use command `ffmpeg -i <mkv_file> -map 0:0 -map 0:1 -vcodec copy -acodec alac -vtag hvc1 "<output>.mov"`, the frame-rate also goes wrong (eg. from 23.98 to 23.81). See also [reddit | Framerate issue in fcp (23.98-23.81 FPS)](https://www.reddit.com/r/ffmpeg/comments/dm5z04/framerate_issue_in_fcp_23982381_fps/)

You should **make a slight adjustment** to the script if your media has a codec different from `mkv format, track 0 HEVC, track 1 FLAC`.

For editing in `FCP`, it's better to use `Apple Prores` to make rendering faster. Choose `proxy` in `FCP` if your `Mac` is under great performance. 

**Notice** Import output files directly into `FCP` because they have the original quality. **Don't** transcode them using some apps which may decrease the quality. (converting to `Apple Prores 422 HQ / 422` just slightly decrease quality and it's convenient if you have a workflow with large storage)

# Other Scrips
Here are some other scripts that convert specific kinds of media.

## Convert BDMV(.m2ts) to mov
`BDMV` owns the best quality for anime. Convert them to mov in order to import them into `FCP` with the best quality.

### Function
Convert `BDMV` anime (with m2ts format, track 0` H264/AVC`, track 1 `PCM`) to `mov` in order to make it importable in `FCP` without recoding.

## Convert FLAC(.flac) to ALAC(.m4a)
`FLAC` is a codec for lossless audio. However, `FCP` or `Compressor` (and also `Music.app`) doesn't support that not-for-industry audio codec.

`ALAC` is also a codec for lossless audio designed by `Apple`. So it has a great support in `macOS`.

### Function
The function of this script is to convert `FLAC` file (with a suffix `.flac`) to `ALAC` (with a suffix `.m4a`).

### Note
You may think command `ffmpeg -i song.flac -acodec alac song.m4a` or `ffmpeg -i song.flac song.m4a` is enough. But unfortunately sometimes it fails. Check here at [Stack Overflow](https://stackoverflow.com/questions/55429909/could-not-find-tag-for-codec-h264-in-stream-0-codec-ffmpeg-flac-to-alac-conver).

# PS
* English is not my native language; please excuse typing errors. 
* Any advice or discussion will be appreciated!