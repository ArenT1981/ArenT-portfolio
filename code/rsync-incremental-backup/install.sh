#!/bin/sh
# EDIT below ==================================================
# Edit this to your preferred location to store the script file:
JOB_LOCATION=~/bin
# Edit this to your preferred scheduled time. See man crontab if you
# are not sure how to specify crontab times. Do not remove the quotation marks.
CRON_SCHEDULE="00 5 * * *"
# END EDITS ===================================================

LOGFILE=install.log

echo "Proceed with intial backup and installation of crontab incremental daily job?"
echo -n "Type 'yes' to confirm\n> "
read CHOICE

if [ "$CHOICE" != "yes" ]; then
        exit 0
fi

mkdir -p $JOB_LOCATION

echo "Doing initial backup..."
cp rsync-incremental.sh $JOB_LOCATION
$JOB_LOCATION/rsync-incremental.sh init | tee $LOGFILE
$JOB_LOCATION/rsync-incremental.sh remote | tee -a $LOGFILE
echo "================================="
echo "Backup complete."
echo "Adding crontab entry..."
(crontab -l 2>/dev/null; echo "$CRON_SCHEDULE $JOB_LOCATION/rsync-incremental remote") | crontab -
echo "Done. Daily incremental backup in place; crontab installed."
echo "View logfile (\"install.log\") for detailed output."
echo "================================="
echo "Current crontab: \n"
crontab -l
echo "================================="
echo "It is recommended to add ~/bin/rsync-incremental to your PATH for easy interactive"
echo "manual use of \"rsync-incremental.sh\" with \"restore\", \"delete\", \"clean\" commands etc."

# =============================================================
# install.sh (for rsync-incremental.sh)
# Author: Aren Tyr (aren.unix@yandex.com)
#
# Date: 2019-12-02
# Version 1.0
#
# =============================================================
# This script implements a simple but effective daily backup strategy
# based on standard GNU gzip and tar utilities. It also remotely backs
# up these archives using rsync. It uses the incremental capabilities of
# tar when used with a snapshot file to make daily incremental backups
# fast and efficient.
#
# Project created by me as my submission for the eduonix DevOps Foundation
# final project.
# =============================================================
