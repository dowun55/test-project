#!/bin/bash

OWNERID=321653183891
REGIONS="ap-northeast-2"
DATE=$(date +%Y%m%d)
DELETEDATE=$(date +%Y%m%d --date="1week ago")

for REGION in $REGIONS; do
        aws ec2 describe-snapshots --region $REGION --owner-id $OWNERID --query 'Snapshots[*].[StartTime,SnapshotId]' --output text > snapshot-list

        while read startTime snapshotId; do
                convertTime=$(date -d $startTime +%Y%m%d)
                if [ "$convertTime" -gt "$DELETEDATE" ]; then continue;
                else
                        #명령줄 입력
                        echo $convertTime
                fi
        done < snapshot-list
done
