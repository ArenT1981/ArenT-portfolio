#!/bin/sh


#FIND_IMAGE_VIDEO="find .. -type f -regex \
#	'.*/*\.\(jpg\|JPG\|png\|PNG\|mpg\|MPG\|mp4\|MP4\|mkv\|MKV\)$' 


#go-mtpfs /media/phone &
#xfe /media/phone 

#fusermount -u /media/phone


IMG_YEAR=-1
IMG_MONTH=-1
IMG_DAY=-1

TIMESTAMP=$(date +%F-%M-%S)

SOURCE_DIR="/media/phone/Internal storage/DCIM/Camera"
PICTURES_DIR="/media/externalHD/backup/phone-pic-test"
LOG_FILE="$PICTURES_DIR/picture-copy.log"
TMP_LOG="/tmp/copylog-$TIMESTAMP.log"
echo "[ $TIMESTAMP ]\n" >> "$LOG_FILE"
find "$SOURCE_DIR" -type f -regex \
	'.*/*\.\(jpg\|JPG\|png\|PNG\|mpg\|MPG\|mp4\|MP4\|mkv\|MKV\|py\|PY\)$' \
	-exec copy-picture-handler.sh {} "$SOURCE_DIR" "$PICTURES_DIR" "$TMP_LOG" \;

FILES_COPIED=`wc -l "$TMP_LOG" | cut -d ' ' -f 1`
cat "$TMP_LOG" >> "$LOG_FILE"
echo "\n# $FILES_COPIED file(s) copied on $TIMESTAMP" >> "$LOG_FILE"
echo "\n --- \n" >> "$LOG_FILE"
echo "$FILES_COPIED new file(s) copied on $TIMESTAMP" 
tree -h -I "*.log" "$PICTURES_DIR" > "/tmp/$TIMESTAMP-photos.copy" 
mv "/tmp/$TIMESTAMP-photos.copy" "$PICTURES_DIR/photolist.txt"
