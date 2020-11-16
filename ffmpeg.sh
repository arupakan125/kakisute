#!/bin/zsh

for TARGET in *.MOV
    do

    ROTATE=$(ffprobe -show_streams -print_format json -v error $TARGET | jq -r '.streams[0].tags.rotate')

    if [ $ROTATE = 90 ]
    then
        echo "true"
        TARGET_WIDTH=720
        TARGET_HEIGHT=1280
    elif [ $ROTATE = 270 ]
    then
        echo "true"
        TARGET_WIDTH=720
        TARGET_HEIGHT=1280
    else
        TARGET_WIDTH=1280
        TARGET_HEIGHT=720
    fi

    TARGET_NAME=${TARGET}.mov
    ffmpeg -i ${TARGET} -movflags use_metadata_tags -map_metadata 0 -c:v libx265 -tag:v hvc1 -s $TARGET_WIDTH'x'$TARGET_HEIGHT -r 30 -map 0 ${TARGET_NAME}
    #ffmpeg -i ${TARGET} -movflags use_metadata_tags -map_metadata 0 -c:v hevc_videotoolbox -tag:v hvc1 -s $TARGET_WIDTH'x'$TARGET_HEIGHT -r 30 -map 0 ${TARGET_NAME}
done
