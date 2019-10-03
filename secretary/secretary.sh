#!/bin/bash
# Author: Aren Tyr
# Date: 2019-10-03
# aren.tyr AT yandex.com
#
# Secretary: A command line program to help automatically reorganise your files
# 
# Configuration is done by editing/creating a configuration file in 
# ~/.secretary/secretaryrc
#  
# Please review the generated operation file before telling it to copy/move 
# your files. You could potentially do a lot of damage to your system otherwise!


showUsage() {
	echo ""
	echo "secretary"
	echo ""
	echo "A program to automatically reorganise and copy/move particular files based on"
	echo "the file extension, MIME type, and/or creation date, to specified directories" 
	echo "according to a configuration file actions." 
	echo ""
	echo "-----------------------------------------------------------------------------"
	echo ""
	echo "Usage: secretary [--yes] [OVERRIDE] [-f <configuration file>] SOURCE"
	echo ""
	echo "Where OVERRIDE can be one of: "
	echo ""
	echo "--cp-update"
	echo "    copy files, updating if source file is newer"
	echo "--cp-clobber"
	echo "    copy files, overwriting any destination files of same filename"
	echo "--mv-no-clobber"
	echo "    move files from source, but do not overwrite any clashing destination files"
	echo "--mv-clobber"
	echo "    move files from source, and overwrite clashing destination files"
	echo ""
	echo "    Use caution with these options as they could result in unintended data loss"
	echo "by updating or overwriting files at the destination(s) specified in the config"
	echo "file.The default action is to copy without clobbering, i.e. do not overwrite" 
	echo "files at the destination. This is the recommended beahaviour; simply delete the"
	echo "source files once you've verified the copy operation has perfomed as intended,"
	echo "if you no longer want/need a copy of them in their original location."
	echo ""
	echo "-f <configuration file>"
	echo ""
	echo "    Supply an alternative configuration file to use instead of the default which"
	echo "is at ~/.secretary/secretaryrc. This is useful for scripting secretary instances,"
	echo "or maintaining multiple secratary 'profiles' for different use-cases, i.e. a "
	echo "config file for processing files off a digital camera, another one for sorting"
	echo "internet dowloads, another one to sort text files, etc. E.g.:"
	echo ""
	echo "secretary ~/my/source/directory -f ~/my_config/my_secretary_rc_file"
	echo ""
	echo "--yes"
	echo ""
	echo "    Do not produce review file; automatically perform the file operations by"
	echo "calling secretary-refile upon the generated file operations log. Take CARE with"
	echo "this, as it will be performing mass file operations according to your settings,"
	echo "with no option to review the operations before proceeding. Intended for"
	echo "experienced users for scripting or automating purposes, typically when combined"
	echo "with the '-f' option above. Most users are strongly recommended to instead "
	echo "REVIEW the file operations log in a text editor BEFORE running it. This"
	echo "allows you to check that it will be copying/moving files in the way that you" 
	echo "want! \"Buyer beware\", \"You have been warned\" etc. etc... ;-) "
	
}

AUTO="NO"
CONF_DIR=$HOME/.secretary
CONF_FILE=$CONF_DIR/secretaryrc
MASTER_LIST=$CONF_DIR/master.files
FILE_OPS_DIR=$CONF_DIR/fileops
SOURCE_DIR=/dev/null

#echo "master: $MASTER_LIST"

if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]; then
	echo "$#"
	showUsage
	exit 2
fi


if [ "$1" = "--yes" ]; then
	AUTO="YES"
	SOURCE_DIR="$2"
	echo "* '--yes' option selected, using AUTO mode..." 
else
	SOURCE_DIR="$1"

fi

echo "* Processing..."

find "$SOURCE_DIR" -type f -exec file {} \; >> $MASTER_LIST

# Build the filelists, parsing the configuration file line-by-line
while read LINE 
do
	COMMENT_HASH="`echo $LINE | cut -c 1`"

	[ "$COMMENT_HASH" = "#" ] && continue

	TYPE_FIELD="`echo $LINE | cut -d ':' -f 1`"
	EXT_FIELD="`echo $LINE | cut -d ':' -f 2`"  
	DEST_FIELD="`echo $LINE | cut -d ':' -f 3`"

	# Process a file extension line by filename
	if [ "$TYPE_FIELD" = "ext" ]; then

		for EXT in $EXT_FIELD
		do
			echo "# -> [ \*.$EXT files ] " > "$CONF_DIR/filelist-$EXT.files"
			 
			grep ".*\.$EXT.*" "$MASTER_LIST" \
			 | cut -d ':' -f 1 \
			 | grep ".*\.$EXT$" \
			 | awk  -v b="\"" -v a="$DEST_FIELD" '/$/{ print b$0b":"b a b }' \
			 >> "$CONF_DIR/filelist-$EXT.files"
		done

	fi

	# Process a MIME type line using file
	if [ "$TYPE_FIELD" = "mime" ]; then
		for MIME in $EXT_FIELD
		do
			echo "# -> [ $MIME files ] " > "$CONF_DIR/filelist-$MIME.files"
			grep ": $MIME" "$MASTER_LIST" \
			| cut -d ':' -f 1 \
			| awk -v b="\"" -v a="$DEST_FIELD" '/$/{ print b$0b":"b a b }' \
			>> "$CONF_DIR/filelist-$MIME.files"
		done
	fi

done < $CONF_FILE

# Remove the filelists with no files to copy
for FILELIST in `ls $CONF_DIR/filelist-*.files`
do
	if [ "`wc -l $FILELIST | cut -d ' ' -f 1`" -eq 1 ]; then
		rm $FILELIST
	fi
done

# Build the final copying script
TIMESTAMP="`date +%Y-%m-%d-%H_%M`"
echo "#!/bin/bash" > $FILE_OPS_DIR/file-operations-$TIMESTAMP.log

read -d '' FILE_HEADER_TXT << "ENDHEADER"
# ---------------------------------------------------------------
# ---------------------------------------------------------------
#
#        [ File operations list generated by secretary ] 
#
# ===============================================================
# ===============================================================
# 
# PLEASE look through this file carefully BEFORE running it
# to ensure that it will copy/move the correct files to 
# your intended destination. Failure to do so may result in data
# loss if you have got your settings wrong if your config file...
# 
# ---------------- YOU HAVE BEEN WARNED!!!!! --------------------
# 
# To execute this script:
#
#    $ secretary run #log#
#
# where "#log#" will be a file of the form
# file-operations-TIMESTAMP.log, for example:
#
#    $ secretary run file-operations-2019-10-03-14_04.log
# 
# (Here the file operations script was created on March 3rd
# 2019, at 14:04 in the afternoon.)
#
# Alternatively you can run it by simply redirecting it to
# bash, e.g.:
# 
#    $ bash < file-operations-2019-10-03-14_04.log
#
# ----------------------------------------------------------------
ENDHEADER

echo "$FILE_HEADER_TXT" >> $FILE_OPS_DIR/file-operations-$TIMESTAMP.log

for FILELIST in `ls $CONF_DIR/filelist-*.files 2> /dev/null`
do
	if [ -s "$FILELIST" ]; 
	then
		HEADER_FLAG=1
		while read FILE_LINE
		do
			if [ $HEADER_FLAG -eq 1 ]; then

				echo "" >> "$FILE_OPS_DIR/file-operations-$TIMESTAMP.log"
				echo "$FILE_LINE" >> "$FILE_OPS_DIR/file-operations-$TIMESTAMP.log"
				echo "" >> "$FILE_OPS_DIR/file-operations-$TIMESTAMP.log"
				HEADER_FLAG=0
				continue
			fi

			FILE="`echo $FILE_LINE | cut -d ':' -f 1`"
			DEST="`echo $FILE_LINE | cut -d ':' -f 2`"
			echo "cp $FILE $DEST" >> $FILE_OPS_DIR/file-operations-$TIMESTAMP.log
		
		done < $FILELIST
	else
		rm $FILELIST 
	fi
done

OPERATIONS=`grep -v '^#' "$FILE_OPS_DIR/file-operations-$TIMESTAMP.log" | wc -l`
echo "" >> "$FILE_OPS_DIR/file-operations-$TIMESTAMP.log"
echo "#-->$OPERATIONS files to copy/move." >> $FILE_OPS_DIR/file-operations-$TIMESTAMP.log

# Clear out the temporary file lists
find "$CONF_DIR" -name "*.files" -delete

echo "* File operations script created at:"
echo "$FILE_OPS_DIR/file-operations-$TIMESTAMP.log"
echo "* $OPERATIONS files to copy/move"

if [ "$AUTO" = "YES" ]; then
	echo "* Running in AUTO mode, executing file operations..."
else
	echo "* Processing complete."
	echo ""
	echo "To now actually copy/move the files, type:"
	echo "bash < $FILE_OPS_DIR/file-operations-$TIMESTAMP.log"
	echo ""
	echo "However, you should really check it over first!"
	echo ""
	echo "Would you like to review it now? (Strongly recommended!)"
	echo ""
	echo "Press <enter> to view it in the terminal pager or type the name of desired text" 
	echo "editor to open it with, e.g. 'xedit' (without the quotes!)"
	echo "Type q to exit this prompt"
	echo -n ">"
	read CHOICE 
	if [ "$CHOICE" = "q" ]; then
		exit 0
	else
		if [ "$CHOICE" = "" ]; then 
			more "$FILE_OPS_DIR/file-operations-$TIMESTAMP.log"
		else
			exec "$CHOICE" "$FILE_OPS_DIR/file-operations-$TIMESTAMP.log"

		fi
	fi
fi
