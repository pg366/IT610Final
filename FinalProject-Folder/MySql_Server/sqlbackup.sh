#!/bin/bash

## Declaration of initial variables for creating a script that takes mysql backup using 
## mysqldump functionality

NOW="$(date +'%F-%H:%M:%S')"
BKPFOLDER="/SQLDB_BKP"
BKPFILE="db_bkp_$NOW".sql.gz
PATHTOBKPFILE="$BKPFOLDER/$BKPFILE"
LOGFOLDER="$BKPFOLDER/BKP_LOGS"
LOGFILE="$LOGFOLDER/bkp_log"

#### Start of the Script ####

echo "Started Mysqldump at $(date +'%F-%H:%M:%S')" >> "$LOGFILE"

#### mysqldump command for executing the dump backup and compressing it  ####

mysqldump --defaults-extra-file=/root/.my.cnf --all-databases | gzip > "$PATHTOBKPFILE"

#### Logging the success or failure of mysqldump to log file based on the exit status of the previous command
#### and notifying the System Admin through Mail for Database backup Success/Failure  ####

if [ $? -eq 0 ]; then
echo "Completed MysqlDump at $(date +'%F-%H:%M:%S')" >> "$LOGFILE"
echo "Completed MysqlDump at $(date +'%F-%H:%M:%S')" | mailx -s "Success: Mysql Backup" pankajg1366@gmail.com
else
echo "Failed MysqlDump at $(date +'%F-%H:%M:%S')" >> "$LOGFILE"
echo "Failed MysqlDump at $(date +'%F-%H:%M:%S')" | mailx -s "Failed: Mysql Backup" pankajg1366@gmail.com
fi

####  Checking the Database Backup files in the backup folder. If they are older than N verion then executing
####  the command to delete the Nth version backup file
 
find "$BKPFOLDER" -name db_bkp_* -mtime +7 -exec rm {} \;

#### Logging the success or failure of previous command to log file based on the previous command and 
#### notifying the System Admin through Mail in case Database backup deletion failed  ####

if [ $? -eq 0 ]; then
echo "Deleted Backup file at $(date +'%F-%H:%M:%S')" >> "$LOGFILE"
else
echo "Failed Deletion of Backup file at $(date +'%F-%H:%M:%S')" >> "$LOGFILE"
echo "Failed Deletion of Backup file at $(date +'%F-%H:%M:%S')" | mailx -s "Failed: Mysql Backup Deleted" pankajg1366@gmail.com
fi

echo "----------------------------------------------------------------------------" >> "$LOGFILE"

###################################  END of Script ###########################################################################
