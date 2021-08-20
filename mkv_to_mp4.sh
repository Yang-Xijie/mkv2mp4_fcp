#!/bin/zsh

#
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
#

turn=1 # counter, make name of intermediate files short.

for anime in **/*.mkv; do
    echo "=====" "[""$turn""]""START" "$anime" "====="

    # Firstly, extract tracks from mkv file.
    # Here, 0 and 1 refer to tracks of the mkv file.
    mkvextract tracks "$anime" 0:"$turn"".h265" 1:"$turn"".flac"

    # Secondly, for the audio, change FLAC (Free Lossless Audio Codec) to ALAC (Apple Lossless Audio Codec).
    # (FLAC is not that compatible with FCP)
    ffmpeg -i "$turn"".flac" -vcodec copy -acodec alac "$turn"".m4a"

    # Then use `mp4box` to put hevc and alac together in an mp4 package.
    mp4box -add "$turn"".h265" -add "$turn"".m4a" "${anime%.*}"".mp4"

    # Finally, don't forget to delete intermidiate files.
    # If you want to move files to trash, use `brew install trash` and then change `rm` to `trash`.
    rm "$turn"".h265" "$turn"".flac" "$turn"".m4a"

    echo "=====" "[""$turn""]""DONE!" "=====\n\n"
    let turn=$turn+1
done

echo "ALL DONE!\n"
