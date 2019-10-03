#!/bin/sh

IMG_YEAR=-1
IMG_MONTH=-1
IMG_DAY=-1

SRC=$2
PIC=$3
LOG=$4
#echo "Log: $4"

#echo "Source: $SRC"
#echo "Pic: $PIC"
#echo "Log: $LOG"

IMG_DATE=$(stat -c %y "$1"| cut -d ' ' -f 1)

IMG_YEAR=`echo $IMG_DATE | cut -d '-' -f 1`
IMG_MONTH=`echo $IMG_DATE | cut -d '-' -f 2`
IMG_DAY=`echo $IMG_DATE | cut -d '-' -f 3`

if [ $IMG_YEAR -eq -1 ]; then
	echo "Invalid file parameter passed: $1" >> /tmp/errorlog-foo.txt
	exit 1
fi

if [ $IMG_MONTH -eq -1 ]; then
	echo "Invalid file parameter passed: $1" >> /tmp/errorlog-foo.txt
	exit 1;
fi

if [ $IMG_DAY -eq -1 ]; then
	echo "Invalid file parameter passed: $1" >> /tmp/errorlog-foo.txt
	exit 1;
fi


#echo "$IMG_YEAR"
#echo "$IMG_MONTH"
#echo "$IMG_DAY"

case $IMG_MONTH in
	01)
		MONTH="01-january"
	;;
	02)
		MONTH="02-february"
		;;
	03)
		MONTH="03-march"
		;;
	04)
		MONTH="04-april"
		;;
	05)
		MONTH="05-may"
		;;
	06)
		MONTH="06-june"
		;;
	07)
		MONTH="07-july"
		;;
	08)
		MONTH="08-august"
		;;
	09)
		MONTH="09-september"
		;;
	10)
		MONTH="10-october"
		;;
	11)
		MONTH="11-november"
		;;
	12)
		MONTH="12-december"
		;;
	*)
		exit 1
		;;
esac

#echo "Month is: $MONTH"
#echo "Filepath is: $1"

DEST_DIR="$PIC/$IMG_YEAR/$MONTH"
#echo "Dest: $DEST_DIR"

#echo "Dest dir is: $DEST_DIR"
#echo "Copy operation would be:\ "
#echo "cp $1 $DEST_DIR"
mkdir -pv $DEST_DIR || echo "Error creating directory: $DEST_DIR"
cp -uv "$1" $DEST_DIR 1>> $LOG 
echo "- Processing: $1"

