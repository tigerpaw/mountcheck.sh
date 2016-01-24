#!/bin/bash

MOUNT_REMOTE="//ip.addr.of.server/Share"
MOUNT_LOCAL="/local/mount/point"
AUTH_TYPE="guest"

if mount | grep $MOUNT_LOCAL > /dev/null; then
    IS_MOUNTED=true
else
    logger $MOUNT_LOCAL is not mounted... attempting to mount now.
    mount.cifs $MOUNT_REMOTE $MOUNT_LOCAL -o $AUTH_TYPE
fi
