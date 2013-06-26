#!/bin/bash
. $(dirname $0)/config.sh

for HOST in $CLIENT_HOSTS; do
    rsync -rcLv $REMOTE_USER@$HOST:$1 $2
done

