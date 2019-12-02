#!/bin/sh
# ============= EDIT THESE THREE PATHS TO CONFIGURE ==================================
# Set this to the SOURCE master directory you wish to BACKUP
BACKUP_DIR=/home/aren/Downloads
# Set this to the DESTINATION directory to store the resultant tar.gz backup archives
BACKUP_LOCATION=/home/aren/Public/backups
# Set this path to the REMOTE/network directory to store the files off-site/non-local (rsync)
REMOTE_LOCATION=/home/aren/Public/remote
# ============= END EDIT =============================================================
# ====================================================================================

# rsync options; all extended attributes, recursive, some status updates
# tar.gz file is already compressed, so no further gain from network compression
RSYNC_COMMAND="rsync -avHAX --info=progress2"

# Get timestamp for archive
TIMESTAMP="`date +%Y-%m-%d-%H_%M_%S`"


# ======== Script functions =========
# Set up the initial main full backup tar.gz file
initial_run()
{
    # Create an initial archive with snapshot.snar as the incremental file list
    #echo "Creating initial backup archive"
    tar -cvzg $BACKUP_LOCATION/snapshot.snar -f $BACKUP_LOCATION/data-backup-01-main-$TIMESTAMP.tar.gz $BACKUP_DIR
    echo "\n================================="
    echo "Backup local SOURCE directory set to: "
    echo $BACKUP_DIR
    echo "Backup local DESTINATION directory set to: "
    echo $BACKUP_LOCATION
    echo "Backup remote rsync location set to: "
    echo $REMOTE_LOCATION
    echo "=================================\n"
}

# Perform an incremental backup
incremental_backup()
{
    tar -cvzg $BACKUP_LOCATION/snapshot.snar -f $BACKUP_LOCATION/data-backup-02-inc-$TIMESTAMP.tar.gz $BACKUP_DIR
}

# Clean out the old backups and make a fresh start 
do_clean_run()
{
    # Clear out old backups
    delete_backups
    # Create a new fresh backup
    initial_run
}

# DELETE all backups!
delete_backups()
{
    # Clear out old backups
    find $BACKUP_LOCATION -type f -name *.tar.gz -delete
    find $BACKUP_LOCATION -type f -name *.snar -delete
}

# This command will restore a backup from the archives
restore_data()
{

    # Extract data to destination directory
    # Backup tar.gz files store the full path, so
    # extraction is relative to root
    for archive in $BACKUP_LOCATION/*.tar.gz
    do
        tar -xvf $archive -C /
    done

}

backup_and_transmit()
{
    # Perform an incremental backup
    incremental_backup
    # Now transmit the archives via rsync
    echo "\n=================================\n"
    echo "Mirroring archives to remote backup location...\n"
    $RSYNC_COMMAND $BACKUP_LOCATION/ $REMOTE_LOCATION/
}

show_usage()
{
    echo "Call with one of:"
    echo "\"init\", \"inc\", \"clean\", \"delete\", \"restore\" or \"remote\" option."
    echo "e.g. \"rsync-incremental remote\""
    echo "See README for more information."
}

# ========= Parse argument/determine mode ==========

# Initialise archive/backup
if [ "$1" = "init" ]; then
    echo "Setting up initial backup archive...\n"
    initial_run
fi

# Incremental run
if [ "$1" = "inc" ]; then
    echo "Performing incremental backup...\n"
    incremental_backup
fi


# Do backup and remotely copy archives
if [ "$1" = "remote" ]; then
    echo "Performing incremental backup and remote copy via rsync...\n"
    backup_and_transmit
fi

# Clean out old files (interactive)
if [ "$1" = "clean" ]; then
    echo -n "WARNING. Delete all old backups and start afresh? Type 'yes' to confirm\n> "
    read CHOICE

    if [ "$CHOICE" = "yes" ]; then
        do_clean_run
        echo "All old backup files deleted; fresh backup created."
    fi

fi

# Delete all backup files
if [ "$1" = "delete" ]; then
    echo -n "WARNING. Delete ALL backup data. Are you sure? Type 'yes' to confirm\n> "
    read CHOICE

    if [ "$CHOICE" = "yes" ]; then
        delete_backups
        echo "All local backup data deleted."
    fi

fi

# Restore from backups (interactive)
if [ "$1" = "restore" ]; then
    echo -n "WARNING. Restore data from backups? Type 'yes' to confirm\n> "
    read CHOICE

    if [ "$CHOICE" = "yes" ]; then
        restore_data
        echo "Data restored from backups."
    fi
fi

if [ "$#" = 0 ] || [ "$1" = "-help" ] || [ "$1" = "--help" ] || [ "$1" = "help" ]; then
	  show_usage
	  exit 0
fi

exit 0
