#!/bin/bash
# written by Tomas Nevar (tomas@lisenet.com)
# 17/01/2014 (dd/mm/yy)
# copyleft free software
# changes to email program, multiple folders by Keith Goodlip 10/08/2014
#
LOGFILE="/var/log/clamav/clamav-$(date +'%Y-%m-%d').log";
EMAIL_MSG="Please see the log file attached.";
EMAIL_FROM="clamav-daily@example.com";
EMAIL_TO="admin@example.com";
EMAIl_PROG="mailx"
DIRTOSCAN=("/home" "/etc" "/bin" "/sbin" "/usr" "/boot" "/root" );

# Check for mail installation
type $EMAIL_PROG >/dev/null 2>&1 || { echo >&2 "I require mail but it's not installed. Aborting."; exit 1; };

# Update ClamAV database
echo "Looking for ClamAV database updates...";
freshclam --quiet;

TODAY=$(date +%u);

if [ "$TODAY" == "6" ];then
        echo "Starting a full weekend scan.";
        # be nice to others while scanning the entire root
        nice -n5 clamscan -ri / --exclude-dir=/sys/ &>"$LOGFILE";
else
        echo -e "Starting the daily scan.\n"&>"$LOGFILE";

        for CURR_DIR in ${DIRTOSCAN[@]}
        do
                echo "Scanning $CURR_DIR"&>>"$LOGFILE";
                DIRSIZE=$(du -sh "$CURR_DIR"  2>/dev/null|cut -f1);
                echo -e "Starting a daily scan of "$CURR_DIR" directory.\nAmount of data to be scanned is "$DIRSIZE".";
                clamscan -ri "$CURR_DIR" &>>"$LOGFILE";
                echo -e "Finished scanning $CURR_DIR\n"&>>"$LOGFILE";
        done
fi

# if the value is not equal to zero, send an email with the log file attached
if [[ $(grep Infected $LOGFILE | awk {'print $3'} | grep -v 0) -ne 0 ]]; then
        echo "$EMAIL_MSG"|$EMAIl_PROG -a "$LOGFILE" -s "ClamAV: Malware Found" -r "$EMAIL_FROM" "$EMAIL_TO";
fi

echo "The script has finished." &>>"$LOGFILE";
exit 0;