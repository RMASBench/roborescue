#!/bin/bash

. $(dirname $0)/config.sh

CLUSTER=$1
MAP=$2
TEAM=$3
NAME=${TEAM_NAMES[$TEAM]}

SERVER=$(getServerHost $CLUSTER)

eval $(ssh $REMOTE_USER@$SERVER cat $KERNELDIR/boot/$LOCKFILE_NAME 2>/dev/null)
if [ ! -z $RUNNING_TEAM ]; then
    echo "There is already a server running on cluster $CLUSTER"
    echo "${TEAM_NAMES[$RUNNING_TEAM]} ($RUNNING_TEAM) on $RUNNING_MAP"
    exit 1
fi;

echo "Starting run for team $NAME ($TEAM) on map $MAP on cluster $CLUSTER."
echo "Starting kernel..."

ssh $REMOTE_USER@$SERVER $SCRIPTDIR/remoteStartKernel.sh $MAP $TEAM&

echo
read -p "Press any key to start agents... " -n1 -s
echo

for i in 1 2 3; do
    CLIENT=$(getClientHost $CLUSTER $i)
    ssh $REMOTE_USER@$CLIENT $SCRIPTDIR/remoteStartAgents.sh $TEAM $SERVER $i $MAP&
done;

sleep 2

echo "Waiting fo run to finish..."

eval $(ssh $REMOTE_USER@$SERVER cat $KERNELDIR/boot/$LOCKFILE_NAME 2>/dev/null)
while [ ! -z $RUNNING_TEAM ]; do
    sleep 5
    unset RUNNING_TEAM
    eval $(ssh $REMOTE_USER@$SERVER cat $KERNELDIR/boot/$LOCKFILE_NAME 2>/dev/null)
done

echo "Evaluating run..."

evalRun.sh $CLUSTER