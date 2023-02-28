#!/usr/bin/env zsh

# - Summary
#
#   Convert anime BDrip (with mkv format, track 0 HEVC, track 1 FLAC)
#   to mp4 package format in order to make it importable
#   in FCP without transcoding (just extract and re-package).
#
# - Discussion
#
#   Use `brew install mkvtoolnix ffmpeg mp4box` to install all necessary tools.
#   (`mp4box` is the same thing as `gpac`)
#   Use `mkvinfo <mkv_file>` to get details of your mkv files.
#   Or use MediaInfo.app to check file info.
#   If the video track of mkv uses AVC (h264), just change `h265` to `h264` in this script.
#
# - SeeAlso
#
#   GitHub Repository https://github.com/Yang-Xijie/mkv2mp4_fcp
#
# - Author
#
#   Yang-Xijie
#   https://github.com/Yang-Xijie

i=1 # counter, make name of intermediate files short.

for anime in **/*.mkv; do
    echo "===== [$i] START $anime ====="

    # Firstly, extract tracks from mkv file.
    # Here, 0 and 1 refer to tracks of the mkv file.
    mkvextract tracks "$anime" "0:$i.h265" "1:$i.flac"

    # Secondly, for the audio, change FLAC (Free Lossless Audio Codec) to ALAC (Apple Lossless Audio Codec).
    # (FLAC is not that compatible with FCP)
    ffmpeg -i "$i.flac" -vcodec copy -acodec alac "$i.m4a"

    # Then use `mp4box` to put hevc and alac together in an mp4 package.
    mp4box -add "$i.h265" -add "$i.m4a" "${anime%.*}.mp4"

    # Finally, don't forget to delete intermediate files.
    # If you want to move files to trash, use `brew install trash` and then change `rm` to `trash`.
    rm "$i.h265" "$i.flac" "$i.m4a"

    echo "===== [$i] DONE! =====\n\n"
    let i=$i+1
done

echo "ALL DONE!\n"
