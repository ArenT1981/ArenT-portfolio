#!/bin/sh
# TODO: Modify gnuplot files column selection for default convert_fit_to_csv.py values
# TODO: Add running exercise type and any others
# TODO: All altitude plot
# TODO: Write simple wrapper script that calls this one with a date range to generate graphs for everything

# Don't allow script to continue with unset variables
set -e

GARMIN_PLOT_TEMPLATES="/home/aren/Documents/garmin/plot-templates"
GARMIN_ACT_DIR="/home/aren/Documents/garmin/activities"
GARMIN_CONV_DIR="/home/aren/.garmin-conv"
GARMIN_OUTPUT_DIR="/home/aren/Documents/garmin/export"
GARMIN_PROCESS_DIR="/home/aren/Opt/garmin-convert/subject_data/conv/fit_csv"
GARMIN_PROCESS_BASE="/home/aren/Opt/garmin-convert/subject_data/conv"

mkdir -p "$GARMIN_CONV_DIR"

echo "Enter date of FIT file to import. Make sure you have imported it into"
echo "/home/Documents/garmin/activities."
echo "Enter date (e.g. \"2019-06-25\"):"
echo -n "> "


if [ "$#" -eq 1 ]; then
    echo "Setting date to $1"
    GARMINFILE="$1"
else
    read GARMINFILE
fi


GARMIN_YEAR="`echo $GARMINFILE | cut -d '-' -f 1`"
GARMIN_MONTH="`echo $GARMINFILE | cut -d '-' -f 2`"
GARMIN_DAY="`echo $GARMINFILE | cut -d '-' -f 3`"

GARMIN_OUTPUT_PATH="$GARMIN_OUTPUT_DIR/$GARMIN_YEAR-$GARMIN_MONTH-$GARMIN_DAY"

case $GARMIN_MONTH in
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
esac

FILTER="grep $GARMIN_YEAR-$GARMIN_MONTH-$GARMIN_DAY"

# Exit for non-existent directory
if [ ! -d "$GARMIN_ACT_DIR/$GARMIN_YEAR/$MONTH" ]; then
    echo "* No directory found containing any files for that date, exiting"
    exit 1
fi



echo "* Copying files"
for MATCH in `ls --full-time "$GARMIN_ACT_DIR/$GARMIN_YEAR/$MONTH" | $FILTER | rev | cut -d ' ' -f 1 | rev`
do
   # echo "Copying $GARMIN_ACT_DIR/$GARMIN_YEAR/$MONTH/$MATCH to temporary directory..."
    cp "$GARMIN_ACT_DIR/$GARMIN_YEAR/$MONTH/$MATCH" "$GARMIN_CONV_DIR"

done

cd /home/aren/Opt/garmin-convert
#find /home/aren/Documents/garmin/activities/2019 -mindepth 1 -type d > /home/aren/Opt/fit2csv/.garmin-dirs.list

#while read LINE
#do

echo "* Converting files to csv format..."
python3 ./process_all.py --subject-name=conv --fit-source-dir="$GARMIN_CONV_DIR" > /dev/null

cd $GARMIN_PROCESS_DIR
#cd /home/aren/Opt/garmin-convert/subject_data/conv/fit_csv

# Delete the junk
if [ ! -s file_log.log ]; then
    echo "* No files found for that date, exiting"
    exit 1
fi

rm file_log.log
rm *_laps.csv
rm *_starts.csv

#ls $GARMIN_PLOT_TEMPLATES

#FIXME: Add massaging for other fields too, which will be added back in...
tidy_fields()
{
    sed -i 's/+01:00//' "$ACTIVITY"
    sed -i 's/timestamp/Time/' "$ACTIVITY"
    sed -i 's/heart_rate/Heart Rate/' "$ACTIVITY"
    sed -i 's/power/Power/' "$ACTIVITY"
    sed -i 's/cadence/Cadence/' "$ACTIVITY"
}


#FIXME: Output should be under year prefix as well, i.e. output-path/garmin-year/garminfoo.png
for ACTIVITY in `ls generic*.csv 2> /dev/null`
do
    FILENAME=\""$ACTIVITY"\"
    echo "* Processing $ACTIVITY"
    tidy_fields $ACTIVITY
    IMAGE_FILENAME="`echo $ACTIVITY | cut -d '.' -f 1`"

    #set +e
    gnuplot -p -e "filename='${ACTIVITY}';" "$GARMIN_PLOT_TEMPLATES"/strength-hr.gnuplot 2>/dev/null
    sleep 1
    #set -e

    if [ ! -s "$GARMIN_PROCESS_DIR"/strength.png ]; then
        rm "$GARMIN_PROCESS_DIR"/strength.png
    else
        mkdir -p "$GARMIN_OUTPUT_PATH"
        mv "$GARMIN_PROCESS_DIR"/strength.png "$GARMIN_OUTPUT_PATH/$IMAGE_FILENAME-custom-hr.png"
        gzip -c "$ACTIVITY" > "$ACTIVITY.gz"
        sleep 0.2
        mv "$ACTIVITY.gz" "$GARMIN_OUTPUT_PATH"
    fi

done

for ACTIVITY in `ls fitness_equipment*.csv 2> /dev/null`
do
    FILENAME=\""$ACTIVITY"\"
    echo "* Processing $ACTIVITY"
    tidy_fields $ACTIVITY
    IMAGE_FILENAME="`echo $ACTIVITY | cut -d '.' -f 1`"

    #set +e
    gnuplot -p -e "filename='${ACTIVITY}';" "$GARMIN_PLOT_TEMPLATES"/strength-hr.gnuplot 2>/dev/null
    sleep 1
    #set -e

    if [ ! -s "$GARMIN_PROCESS_DIR"/strength.png ]; then
        rm "$GARMIN_PROCESS_DIR"/strength.png
    else
        mkdir -p "$GARMIN_OUTPUT_PATH"
        mv "$GARMIN_PROCESS_DIR"/strength.png "$GARMIN_OUTPUT_PATH/$IMAGE_FILENAME-gym-machine-hr.png"
        gzip -c "$ACTIVITY" > "$ACTIVITY.gz"
        sleep 0.2
        mv "$ACTIVITY.gz" "$GARMIN_OUTPUT_PATH"
    fi

done

for ACTIVITY in `ls training*.csv 2> /dev/null`
do
    FILENAME=\""$ACTIVITY"\"
    echo "* Processing $ACTIVITY"
    tidy_fields $ACTIVITY
    IMAGE_FILENAME="`echo $ACTIVITY | cut -d '.' -f 1`"

    #set +e
    gnuplot -p -e "filename='${ACTIVITY}';" "$GARMIN_PLOT_TEMPLATES"/strength-hr.gnuplot 2>/dev/null
    sleep 1
    #set -e

    if [ ! -s "$GARMIN_PROCESS_DIR"/strength.png ]; then
        rm "$GARMIN_PROCESS_DIR"/strength.png
    else
        mkdir -p "$GARMIN_OUTPUT_PATH"
        mv "$GARMIN_PROCESS_DIR"/strength.png "$GARMIN_OUTPUT_PATH/$IMAGE_FILENAME-strength-hr.png"
        gzip -c "$ACTIVITY" > "$ACTIVITY.gz"
        sleep 0.2
        mv "$ACTIVITY.gz" "$GARMIN_OUTPUT_PATH"
    fi

done

for ACTIVITY in `ls walking*.csv 2> /dev/null`
do
    FILENAME=\""$ACTIVITY"\"
    echo "* Processing $ACTIVITY"
    tidy_fields $ACTIVITY
    IMAGE_FILENAME="`echo $ACTIVITY | cut -d '.' -f 1`"
    gnuplot -p -e "filename='${ACTIVITY}';" "$GARMIN_PLOT_TEMPLATES"/walking.gnuplot 2>/dev/null

    sleep 1

    if [ ! -s "$GARMIN_PROCESS_DIR"/walking.png ]; then
        rm "$GARMIN_PROCESS_DIR"/walking.png
    else
        mkdir -p "$GARMIN_OUTPUT_PATH"
        mv "$GARMIN_PROCESS_DIR"/walking.png "$GARMIN_OUTPUT_PATH/$IMAGE_FILENAME-hr.png"
        gzip -c "$ACTIVITY" > "$ACTIVITY.gz"
        sleep 0.2
        mv "$ACTIVITY.gz" "$GARMIN_OUTPUT_PATH"
    fi

done

for ACTIVITY in `ls rowing*.csv 2> /dev/null`
do
    echo "* Processing $ACTIVITY"
    tidy_fields $ACTIVITY
    IMAGE_FILENAME="`echo $ACTIVITY | cut -d '.' -f 1`"
    gnuplot -p -e "filename='${ACTIVITY}';" "$GARMIN_PLOT_TEMPLATES"/rowing-hr-cadence.gnuplot 2>/dev/null

    sleep 1

    if [ ! -s "$GARMIN_PROCESS_DIR"/rowing.png ]; then
        rm "$GARMIN_PROCESS_DIR"/rowing.png
    else
        mkdir -p "$GARMIN_OUTPUT_PATH"
        mv "$GARMIN_PROCESS_DIR"/rowing.png "$GARMIN_OUTPUT_PATH/$IMAGE_FILENAME.png"
        gzip -c "$ACTIVITY" > "$ACTIVITY.gz"
        sleep 0.2
        mv "$ACTIVITY.gz" "$GARMIN_OUTPUT_PATH"
    fi

done

#FIXME: Check this. Running power captured? Or is it just a Garmin IQ field?
# In which case just use rowing plot, as that captures hr + cadence
for ACTIVITY in `ls running*.csv 2> /dev/null`
do
    FILENAME=\""$ACTIVITY"\"
    echo "* Processing $ACTIVITY"
    tidy_fields $ACTIVITY
    IMAGE_FILENAME="`echo $ACTIVITY | cut -d '.' -f 1`"
    gnuplot -p -e "filename='${ACTIVITY}';" "$GARMIN_PLOT_TEMPLATES"/cycling-hr-power-cadence.gnuplot 2> /dev/null || true

    sleep 1

    if [ ! -s "$GARMIN_PROCESS_DIR"/cycling-hr-pwr-cadence.png ]; then
        rm "$GARMIN_PROCESS_DIR"/cycling-hr-pwr-cadence.png
    else
        mkdir -p "$GARMIN_OUTPUT_PATH"
        mv "$GARMIN_PROCESS_DIR"/cycling-hr-pwr-cadence.png "$GARMIN_OUTPUT_PATH/$IMAGE_FILENAME-hr-power-cadence.png"
        gzip -c "$ACTIVITY" > "$ACTIVITY.gz"
        sleep 0.2
        mv "$ACTIVITY.gz" "$GARMIN_OUTPUT_PATH"
    fi

    #sleep 1

    gnuplot -p -e "filename='${ACTIVITY}';" "$GARMIN_PLOT_TEMPLATES"/cycling-hr.gnuplot 2>/dev/null || true

    sleep 1

    if [ ! -s "$GARMIN_PROCESS_DIR"/cycling-hr.png ]; then
        rm "$GARMIN_PROCESS_DIR"/cycling-hr.png
    else
        mkdir -p "$GARMIN_OUTPUT_PATH"
        mv  "$GARMIN_PROCESS_DIR"/cycling-hr.png "$GARMIN_OUTPUT_PATH/$IMAGE_FILENAME-hr.png"
        gzip -c "$ACTIVITY" > "$ACTIVITY.gz"
        sleep 0.2
        mv "$ACTIVITY.gz" "$GARMIN_OUTPUT_PATH"
    fi

done

for ACTIVITY in `ls cycling*.csv 2> /dev/null`
do
    FILENAME=\""$ACTIVITY"\"
    echo "* Processing $ACTIVITY"
    tidy_fields $ACTIVITY
    IMAGE_FILENAME="`echo $ACTIVITY | cut -d '.' -f 1`"
    gnuplot -p -e "filename='${ACTIVITY}';" "$GARMIN_PLOT_TEMPLATES"/cycling-hr-power-cadence.gnuplot 2> /dev/null || true

    sleep 1

    if [ ! -s "$GARMIN_PROCESS_DIR"/cycling-hr-pwr-cadence.png ]; then
        rm "$GARMIN_PROCESS_DIR"/cycling-hr-pwr-cadence.png
    else
        mkdir -p "$GARMIN_OUTPUT_PATH"
        mv "$GARMIN_PROCESS_DIR"/cycling-hr-pwr-cadence.png "$GARMIN_OUTPUT_PATH/$IMAGE_FILENAME-hr-power-cadence.png"
        gzip -c "$ACTIVITY" > "$ACTIVITY.gz"
        sleep 0.2
        mv "$ACTIVITY.gz" "$GARMIN_OUTPUT_PATH"
    fi

    #sleep 1

    gnuplot -p -e "filename='${ACTIVITY}';" "$GARMIN_PLOT_TEMPLATES"/cycling-hr.gnuplot 2>/dev/null || true

    sleep 1

    if [ ! -s "$GARMIN_PROCESS_DIR"/cycling-hr.png ]; then
        rm "$GARMIN_PROCESS_DIR"/cycling-hr.png
    else
        mkdir -p "$GARMIN_OUTPUT_PATH"
        mv  "$GARMIN_PROCESS_DIR"/cycling-hr.png "$GARMIN_OUTPUT_PATH/$IMAGE_FILENAME-hr.png"
        gzip -c "$ACTIVITY" > "$ACTIVITY.gz"
        sleep 0.2
        mv "$ACTIVITY.gz" "$GARMIN_OUTPUT_PATH"
    fi

done

sleep 0.2
echo "* Completed"

if [ -d "$GARMIN_OUTPUT_PATH" ]; then
    tree "$GARMIN_OUTPUT_PATH"
fi

trash-put "$GARMIN_CONV_DIR"
trash-put "$GARMIN_PROCESS_BASE"
