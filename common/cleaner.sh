#!/system/bin/sh

#Executed after Glitchify script
#Log file location
LOG_FILE=/storage/emulated/0/logs/zipalign.log

#Interval between ZipAlign runs, in seconds, 216000 = 60 hours
RUN_EVERY=216000

# Get the last modify date of the Log file, if the file does not exist, set value to 0
if [ -e $LOG_FILE ]; then
    LASTRUN=`stat -t $LOG_FILE | awk '{print $14}'`
else
    LASTRUN=0
fi;

# Get current date in epoch format
CURRDATE=`date +%s`

# Check the interval
INTERVAL=$(expr $CURRDATE - $LASTRUN)

# If interval is more than the set one, then run the main script
if [ $INTERVAL -gt $RUN_EVERY ];
then
    if [ -e $LOG_FILE ]; then
        rm $LOG_FILE;
    fi;

    echo "Starting auto ZipAlign $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
    for apk in /data/app/*.apk ; do
        zipalign -c 4 $apk;
        ZIPCHECK=$?;
        if [ $ZIPCHECK -eq 1 ]; then
            echo ZipAligning $(basename $apk)  | tee -a $LOG_FILE;
            zipalign -f 4 $apk /cache/$(basename $apk);

            if [ -e /cache/$(basename $apk) ]; then
                cp -f -p /cache/$(basename $apk) $apk  | tee -a $LOG_FILE;
                rm /cache/$(basename $apk);
            else
                echo ZipAligning $(basename $apk) Failed  | tee -a $LOG_FILE;
            fi;
        else
            echo ZipAlign already completed on $apk  | tee -a $LOG_FILE;
        fi;
    done;
    echo "Auto ZipAlign finished at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
fi
#----------------------------------------------------------------------------------------------------------------------------

# Log file location
LOG_FILE=/storage/emulated/0/logs/db.log

#Interval between SQLite3 runs, in seconds, 172800=2 days
RUN_EVERY=216000

# Get the last modify date of the Log file, if the file does not exist, set value to 0
if [ -e $LOG_FILE ]; then
    LASTRUN=`stat -t $LOG_FILE | awk '{print $14}'`
else
    LASTRUN=0
fi;

# Get current date in epoch format
CURRDATE=`date +%s`

# Check the interval
INTERVAL=$(expr $CURRDATE - $LASTRUN)

# If interval is more than the set one, then run the main script
if [ $INTERVAL -gt $RUN_EVERY ];
then
    if [ -e $LOG_FILE ]; then
        rm $LOG_FILE;
    fi;

    echo "SQLite database VACUUM and REINDEX started at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;

    for i in `find /d* -iname "*.db"`; do
        sqlite3 $i 'VACUUM;';
        resVac=$?
        if [ $resVac == 0 ]; then
            resVac="SUCCESS";
        else
            resVac="ERRCODE-$resVac";
        fi;

        sqlite3 $i 'REINDEX;';
        resIndex=$?
        if [ $resIndex == 0 ]; then
            resIndex="SUCCESS";
        else
            resIndex="ERRCODE-$resIndex";
        fi;
        echo "Database $i:  VACUUM=$resVac  REINDEX=$resIndex" | tee -a $LOG_FILE;
    done

    echo "SQLite database VACUUM and REINDEX finished at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
fi;
#-----------------------------------------------------------------------------------
# Junk Cleaner
#
LOG_FILE=/storage/emulated/0/logs/junk.log

#Interval between SQLite3 runs, in seconds, 216000 = 60 hours
RUN_EVERY=216000

# Get the last modify date of the Log file, if the file does not exist, set value to 0
if [ -e $LOG_FILE ]; then
    LASTRUN=`stat -t $LOG_FILE | awk '{print $14}'`
else
    LASTRUN=0
fi;

# Get current date in epoch format
CURRDATE=`date +%s`

# Check the interval
INTERVAL=$(expr $CURRDATE - $LASTRUN)

# If interval is more than the set one, then run the main script
if [ $INTERVAL -gt $RUN_EVERY ];
then
    if [ -e $LOG_FILE ]; then
        rm $LOG_FILE;
    fi;

	echo "Junk cleaner started at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
	echo "Remove junk files and app cache" | tee -a $LOG_FILE;

	rm -f /cache/*.apk
	rm -f /cache/*.tmp
	rm -f /cache/*.log
	rm -f /cache/*.txt
	rm -f /cache/recovery/*
	rm -f /data/*.log
	rm -f /data/*.txt
	rm -f /data/anr/*.log
	rm -f /data/anr/*.txt
	rm -f /data/backup/pending/*.tmp
	rm -f /data/cache/*.*
	rm -f /data/dalvik-cache/*.apk
	rm -f /data/dalvik-cache/*.tmp
	rm -f /data/dalvik-cache/*.log
	rm -f /data/dalvik-cache/*.txt
	rm -f /data/data/*.log
	rm -f /data/data/*.txt
	rm -f /data/log/*.log
	rm -f /data/log/*.txt
	rm -f /data/local/*.apk
	rm -f /data/local/*.log
	rm -f /data/local/*.txt
	rm -f /data/local/tmp/*.log
	rm -f /data/local/tmp/*.txt
	rm -f /data/last_alog/*.log
	rm -f /data/last_alog/*.txt
	rm -f /data/last_kmsg/*.log
	rm -f /data/last_kmsg/*.txt
	rm -f /data/mlog/*
	rm -f /data/tombstones/*.log
	rm -f /data/tombstones/*.txt
	rm -f /data/system/*.log
	rm -f /data/system/*.txt
	rm -f /data/system/dropbox/*.log
	rm -f /data/system/dropbox/*.txt
	rm -f /data/system/usagestats/*.log
	rm -f /data/system/usagestats/*.txt
	
	for dir in `find /data/data -type d -iname "*cache*"`; do
	find "$dir" -type f -delete
	done;
	
	echo "Junk cleaner finished at $( date +"%m-%d-%Y %H:%M:%S" )" | tee -a $LOG_FILE;
	echo "------------------------------------------------" | tee -a $LOG_FILE;
fi;
exit 0
# Done!