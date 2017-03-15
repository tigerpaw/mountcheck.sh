#!/bin/bash
# mountcheck.sh
# Example Cron: * * * * * /bin/bash /usr/local/bin/mountcheck.sh

# Set logfile and clear it each run
LOGFILE="/var/log/$(basename "$0").log"
echo "" > $LOGFILE

if /usr/sbin/mount.cifs -V > /dev/null; then 
    echo "" > /dev/null
else 
    echo "Unable to use command: \"mount.cifs\"" >> $LOGFILE
    exit 1
fi

# Mount points in <CIFS|MOUNT>;<REMOTE>;<LOCAL> format
MOUNTS=(
    "cifs;\\\\1.3.3.7\\Share\\Stuff;/mnt/stuff"
    "mount;/dev/xvdb;/mnt/junk"
)

# Clear variables
RUN=0
MOUNT_TYPE=""
LOCAL=""
REMOTE=""

# Check mounts
for m in ${MOUNTS[@]}
do 
    for i in $(echo $m | tr ";" "\n")
    do 
        if [ $RUN == 0 ]; then
            MOUNT_TYPE=$i
            RUN=1
        elif [ $RUN == 2 ]; then
            LOCAL=$i
            if /usr/bin/mount | grep $LOCAL > /dev/null; then
                echo "$REMOTE is already mounted at $LOCAL" >> $LOGFILE
            else
                case "$MOUNT_TYPE" in
                    cifs)
                        /usr/sbin/mount.cifs $REMOTE $LOCAL -o guest >> $LOGFILE
                        ;;
                    *)
                        /usr/bin/mount $REMOTE $LOCAL >> $LOGFILE
                esac
            fi
            RUN=0
        else
            REMOTE=$i
            RUN=2
        fi
    done
done