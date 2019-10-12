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
MASTER_LIST=$CONF_DIR/master
FILE_OPS_DIR=$CONF_DIR/fileops
SOURCE_DIR=/dev/null
DATE_MODE_LOG=$CONF_DIR/filelist-datemode.files
CMD="cp -uv"


if [ ! -z "$EDITOR" ]; then
    EDIT_VIEW="$EDITOR"
else
    EDIT_VIEW="vi"
fi
# TODO    Replace with case
# if [ -z "$DISPLAY" ]; then # Are we running under X?
#     if [ -f "/usr/bin/gedit" ]; then
#         EDIT_VIEW="gedit"
#     
#     if [ -f "/usr/bin/kate" ]; then
#         EDIT_VIEW="kate"
#     else
#     if [ -f "/usr/bin/featherpad" ]; then
#         EDIT_VIEW="featherpad"
#     else
#     if [ -f "/usr/bin/mousepad" ]; then
#         EDIT_VIEW="mousepad"
#     else
#     if [ -f "/usr/bin/xedit" ]; then
#         EDIT_VIEW="xedit"
#     fi
# fi
#     else
#         if [ -f "/bin/nano" ]; then
#             EDIT_VIEW="nano"
#         fi
#     else
#         if [ -f "/usr/bin/vi" ]; then
#             EDIT_VIEW="vi"
#         fi
#     else
#         if [ -f "/usr/bin/emacs" ]; then
#             EDIT_VIEW="emacs"
#         fi
# fi


#if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]; then
#	echo "$#"
#	showUsage
#	exit 2
#fi


if [ "$1" = "--yes" ]; then
	AUTO="YES"
	SOURCE_DIR="$2"
	echo "* '--yes' option selected, using AUTO mode..."
else
	SOURCE_DIR="$1"

fi

# Counter for enumerating temporary filenames
declare -i COUNTER=0

echo "* Processing, please wait..."
sleep 0.4
# Build the filelists, parsing the configuration file line-by-line
while read LINE
do
    echo -n "."

  DATE_MODE="DISABLE"

	COMMENT_HASH="`echo $LINE | cut -c 1`"
	[ "$COMMENT_HASH" = "#" ] && continue

	TYPE_FIELD="`echo $LINE | cut -d ':' -f 1`"
	EXT_FIELD="`echo $LINE | cut -d ':' -f 2`"
  SOURCE_FIELD="`echo $LINE | cut -d ':' -f 3`"
	DEST_FIELD="`echo $LINE | cut -d ':' -f 4`"
	DATE_CHECK="`echo $DEST_FIELD | grep ".*DATE#.*" -`"

  FILE_CMD="`echo $LINE | cut -d ':' -f 5`"
  #echo $FILE_CMD
  #if [ "$FILE_CMD" = "#" ]; then
  #    CMD="cp -uv"
  #else
  #    CMD="$FILE_CMD"
  #fi




	# See whether DATE mode is active; cut out 'DATE#' text if so
	if [ -n "$DATE_CHECK" ]; then
		DATE_MODE="ENABLE"
		DEST_FIELD=$(echo $DEST_FIELD | cut -d '#' -f 2)
	fi

	# Process a file extension line by filename
	if [ "$TYPE_FIELD" = "ext" ]; then

		for EXT in $EXT_FIELD
		do
        echo -n "."
        if [ "$DATE_MODE" = "ENABLE" ]; then
				#echo "# -> [ \*.$EXT files by DATE directories ] " > "$CONF_DIR/datemode-$COUNTER-$EXT.files"

				# Fork off the hierarchical date script
				find "$SOURCE_FIELD" -type f  -regex \
					".*/*\.$EXT$" \
					-exec secretary-date-handler.sh {} "$SOURCE_FIELD" "$DEST_FIELD" "$CONF_DIR/datemode-$COUNTER-$EXT.files" "$CONF_DIR/datemode-$COUNTER-$EXT.dirlist" "$CMD" \;

        # Insert header or remove empty filelist 
        if [ -s "$CONF_DIR/datemode-$COUNTER-$EXT.files" ]; then
            sed -i "1i# -> [ \*.$EXT files from $SOURCE_FIELD to DATE directories ]" "$CONF_DIR/datemode-$COUNTER-$EXT.files"
        else
            if [ -f "$CONF_DIR/datemode-$COUNTER-$EXT.files" ]; then
                rm "$CONF_DIR/datemode-$COUNTER-$EXT.files"
            fi
        fi

			else
          echo -n "."
          # Copy/move the files by file-extension, no date ordering/organisation
          find "$SOURCE_FIELD" -type f >> "$MASTER_LIST.$COUNTER.files"

			#echo "# -> [ \*.$EXT files ] " > "$CONF_DIR/filelist-$COUNTER-$EXT.files"
	#		grep ".*\.$EXT.*" "$MASTER_LIST" \
	#		 | cut -d ':' -f 1 \
	#		 | grep ".*\.$EXT$" \
	#		 | awk  -v b="\"" -v a="$DEST_FIELD" '/$/{ print b$0b":"b a b }' \
	#		 >> "$CONF_DIR/filelist-$EXT.files"
          echo -n "."
	   	grep ".*\.$EXT.*" "$MASTER_LIST.$COUNTER.files" \
	        		 | grep ".*\.$EXT$" \
	        		 | awk  -v b="\"" -v a="$DEST_FIELD" '/$/{ print b$0b":"b a b }' \
	        		        >> "$CONF_DIR/filelist-$COUNTER-$EXT.files"

      # Insert header or remove empty filelist
      if [ -s "$CONF_DIR/filelist-$COUNTER-$EXT.files" ]; then
          sed -i "1i# -> [ \*.$EXT files from $SOURCE_FIELD to $DEST_FIELD ]" "$CONF_DIR/filelist-$COUNTER-$EXT.files"
      else
          rm "$CONF_DIR/filelist-$COUNTER-$EXT.files"
      fi
			fi
		done
	fi

	# Process a MIME type line using file
	if [ "$TYPE_FIELD" = "mime" ]; then


      echo -n "."
      find "$SOURCE_FIELD" -type f -exec file {} \; >> "$MASTER_LIST.$COUNTER.files"


		for MIME in $EXT_FIELD
		do
        echo -n "."
	      if [ "$DATE_MODE" = "ENABLE" ]; then
				  # use sed i1 later echo "# -> [ $MIME files by DATE directories ] " > "$CONF_DIR/datemode-$COUNTER-$MIME.files"
                grep ": $MIME" "$MASTER_LIST.$COUNTER.files" \
			          | cut -d ':' -f 1 \
			          | awk -v a="$DEST_FIELD" '/$/{ print $0":"a }' \
			          >> "$CONF_DIR/filelist-$COUNTER-$MIME.files"

                while read MIMELINE
                do
                    echo -n "."
                #echo "In datemode by MIME"
                MIME_FILE="`echo $MIMELINE | cut -d ':' -f 1`"
                MIME_SRC="`echo $MIME_FILE | rev | cut -d '/' -f 2- | rev`"
                MIME_DEST="`echo $MIMELINE | cut -d ':' -f 2`"

                #debug ----
                #echo "Mime src: $MIME_SRC"
               # echo "Mime dest: $MIME_DEST"
                # ------
                secretary-date-handler.sh "$MIME_FILE" "$MIME_SRC" "$DEST_FIELD" "$CONF_DIR/datemode-$COUNTER-$MIME.files" "$CONF_DIR/datemode-$COUNTER-$MIME.dirlist" "$CMD"
                done < $CONF_DIR/filelist-$COUNTER-$MIME.files

                # Add header if results found, otherwise purge file 
                if [ -s "$CONF_DIR/datemode-$COUNTER-$MIME.files" ]; then
                    sed -i "1i# -> [ $MIME files from $SOURCE_FIELD by DATE directories ]" "$CONF_DIR/datemode-$COUNTER-$MIME.files"
                else
                    if [ -f "$CONF_DIR/datemode-$COUNTER-$MIME.files" ]; then
                        rm "$CONF_DIR/datemode-$COUNTER-$MIME.files"
                    fi
                fi
                # Avoid duplicate file operations as we have now built a list by date from original search
                rm "$CONF_DIR/filelist-$COUNTER-$MIME.files"
     else
         echo -n "."

         grep ": $MIME" "$MASTER_LIST.$COUNTER.files" \
			       | cut -d ':' -f 1 \
			       | awk -v b="\"" -v a="$DEST_FIELD" '/$/{ print b$0b":"b a b }' \
			             >> "$CONF_DIR/filelist-$COUNTER-$MIME.files"


            if [ -s "$CONF_DIR/filelist-$COUNTER-$MIME.files" ]; then
                sed -i "1i# -> [ $MIME files from $SOURCE_FIELD to $DEST_FIELD ]" "$CONF_DIR/filelist-$COUNTER-$MIME.files"
            else
                rm "$CONF_DIR/filelist-$COUNTER-$MIME.files"
            fi

fi
 		done
	fi

  COUNTER=$COUNTER+1

done < $CONF_FILE

echo -n "."
# Remove the filelists with no files to copy
#for FILELIST in `ls $CONF_DIR/filelist-*.files`
#do#=
#	if [ "`wc -l $FILELIST | cut -d ' ' -f 1`" -eq 1 ]; then
#		rm $FILELIST
#	fi
#done

# Build the final copying script
TIMESTAMP="`date +%Y-%m-%d-%H_%M`"
echo "#!/bin/bash" > $FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh

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
#    $ bash run #log#
#
# where "#log#" will be a file of the form
# secretary-file-operations-TIMESTAMP.sh, for example:
#
#    $ bash run secretary-file-operations-2019-10-03-14_04.sh
#
# (Here the file operations script was created on March 3rd
# 2019, at 14:04 in the afternoon.)
#
# If you select the "--yes" option you will bypass this message
# and have the operations automatically performed. Use with care.
#
#
# ----------------------------------------------------------------
ENDHEADER

echo "$FILE_HEADER_TXT" >> $FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh

# Assemble all the non date ordered file lists into the work log
for FILELIST in `ls $CONF_DIR/filelist-*.files 2> /dev/null`
do
    echo -n "."
	if [ -s "$FILELIST" ];
	then
		HEADER_FLAG=1
		while read FILE_LINE
		do
        echo -n "."
			if [ $HEADER_FLAG -eq 1 ]; then

				echo "" >> "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
				echo "$FILE_LINE" >> "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
				echo "" >> "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
				HEADER_FLAG=0
				continue
			fi

			FILE="`echo $FILE_LINE | cut -d ':' -f 1`"
			DEST="`echo $FILE_LINE | cut -d ':' -f 2`"
			echo "$CMD $FILE $DEST" >> $FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh

		done < $FILELIST
	else
		rm $FILELIST
	fi
done

# Gather together the directory creation and throw away duplicate mkdir -pv commands
# for aesthetic and clarity purposes (would still run OK with them all in)
cat $CONF_DIR/datemode-*.dirlist >> $CONF_DIR/tmp-master.dirlist
cat $CONF_DIR/tmp-master.dirlist | sort | uniq >> $CONF_DIR/master.dirlist

sed -i '1i# -> [ Create directories for date based file copying/moving ]\n' "$CONF_DIR/master.dirlist"
echo "" >> "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
echo "" >> "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
cat "$CONF_DIR/master.dirlist" >> "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"

for FILELIST in `ls $CONF_DIR/datemode-*.files 2> /dev/null`
do
    echo -n "."
	if [ -s "$FILELIST" ];
	then
		HEADER_FLAG=1
		while read FILE_LINE
		do
			if [ $HEADER_FLAG -eq 1 ]; then

				echo "" >> "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
				echo "$FILE_LINE" >> "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
				echo "" >> "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
				HEADER_FLAG=0
				continue
			fi


			echo "$FILE_LINE" >> $FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh

		done < $FILELIST
	else
		rm $FILELIST
	fi
done

# Put footer information at bottom of operations list with summary data
OPERATIONS=`egrep -v '^#|^mkdir|^$' "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh" | wc -l`
DIRS=`grep '^mkdir' "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh" | wc -l`
echo "" >> "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
echo "#--> $DIRS new directories to create." >> $FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh
echo "#--> $OPERATIONS files to copy/move." >> $FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh

# Clear out the temporary file lists
find "$CONF_DIR" -name "*.files" -delete
find "$CONF_DIR" -name "*.dirlist" -delete

echo ""
echo "* Processing complete."
echo "* $OPERATIONS files ready to copy/move."
echo "* File operations script created at:"
echo ""
echo "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"


# Check to see whether they're brave enough for AUTO...
if [ "$AUTO" = "YES" ]; then
    echo ""
	  echo "* Running in AUTO mode, will now execute the file operations..."
	  sleep 1
    bash "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh" | tee secretary-$TIMESTAMP.log
    echo ""
    echo "* Complete. File transactions finished."
    echo "* Logfile showing operations performed created at:"
    echo "$FILE_OPS_DIR/secretary-$TIMESTAMP.log"
else
    echo ""
    echo "* You should now review the proposed file operations."
    echo ""
    echo "Reviewing the file operations script BEFORE operation is STRONGLY "
    echo "RECOMMENDED. PLEASE ENSURE YOU ARE COPYING/MOVING FILES AS INTENDED."
    echo "FAILURE TO DO SO COULD RESULT IN DATA LOSS AS THE SCRIPT IS PERFORMING BATCH"
    echo "FILE OPERATIONS. YOU HAVE BEEN WARNED..."
    echo ""
    echo "------------------------------------------------------------------------"
    echo "If all looks good, to go ahead and actually copy/move the files, exit this prompt"
    echo "('q') and execute the script:"
    echo ""
    echo "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
    echo "------------------------------------------------------------------------"
    echo ""
    echo "* Press:"
    echo " <enter> to view it in the terminal pager"
    echo " <e> to view it in your editor."
    echo " any other key to quit this prompt."
    echo -n "> "
    read CHOICE

    if [ "$CHOICE" = "e" ]; then
            "$EDIT_VIEW" "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
            chmod u+x "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
            exit 0
    fi

    if [ "$CHOICE" = "" ]; then
        more "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
        chmod u+x "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
        exit 0
    fi

chmod u+x "$FILE_OPS_DIR/secretary-file-operations-$TIMESTAMP.sh"
exit 0

fi
fi

# TODO Test for and create any non-existence directories based on source dir
