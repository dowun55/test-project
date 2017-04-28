#Get instanceId from metadata
instanceid=`wget -q -O - http://instance-data/latest/meta-data/instance-id`
LOGFILE="/home/ubuntu/$instanceid.$(date +"%Y%m%d_%H%M%S").log"

#Run Hello World and redirect output to a log file
echo "Hello World from $instanceid" > $LOGFILE

#Copy log file to S3 logs folder
aws s3 cp $LOGFILE s3://csy-test-bucket/logs/
