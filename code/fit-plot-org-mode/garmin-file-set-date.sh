#!/bin/sh

FILE_YEAR="`echo "$1" | cut -d '_' -f 2`"
FILE_MONTH="`echo "$1" | cut -d '_' -f 3`"
FILE_DAY="`echo "$1" | cut -d '_' -f 4`"


echo "File $1 date is: "
echo "$FILE_YEAR-$FILE_MONTH-$FILE_DAY"


touch --date="$FILE_YEAR-$FILE_MONTH-$FILE_DAY" "$1"
