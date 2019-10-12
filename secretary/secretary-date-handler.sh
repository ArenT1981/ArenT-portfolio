#!/bin/sh

ERROR_FILE=$HOME/.secretary/errorlog
FILE_YEAR=-1
FILE_MONTH=-1
FILE_DAY=-1

FIRST=$1
SRC=$2
DEST=$3
LOG=$4
DIRLOG=$5
OPERATION=$6
#echo "Log: $4"

#echo "First: $FIRST"
#echo "Source: $SRC"
#echo "Pic: $PIC"
#echo "Log: $LOG"

if [ -z "$FIRST" ]; then
    exit 0
fi



FILE_DATE=$(stat -c %y "$1"| cut -d ' ' -f 1)
FILE_YEAR=`echo $FILE_DATE | cut -d '-' -f 1`
FILE_MONTH=`echo $FILE_DATE | cut -d '-' -f 2`
FILE_DAY=`echo $FILE_DATE | cut -d '-' -f 3`

if [ $FILE_YEAR -eq -1 ]; then
	echo "Invalid file parameter passed: $1" >> "$ERROR_FILE"
	exit 1
fi

if [ $FILE_MONTH -eq -1 ]; then
	echo "Invalid file parameter passed: $1" >> "$ERROR_FILE"
	exit 1;
fi

if [ $FILE_DAY -eq -1 ]; then
	echo "Invalid file parameter passed: $1" >> "$ERROR_FILE" 
	exit 1;
fi


#echo "$FILE_YEAR"
#echo "$FILE_MONTH"
#echo "$FILE_DAY"

case $FILE_MONTH in
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

DEST_DIR="$DEST/$FILE_YEAR/$MONTH"
#echo "Dest: $DEST_DIR"

#echo "Dest dir is: $DEST_DIR"
#echo "Copy operation would be:\ "
echo "mkdir -pv $DEST_DIR" >> $DIRLOG
echo "$OPERATION \"$1\" \"$DEST_DIR\"" >> $LOG
#cp -uv "$1" $DEST_DIR 1>> $LOG 
#echo "- Processing: $1"

