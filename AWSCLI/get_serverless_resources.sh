#!/bin/bash

REGIONS=$(aws ec2 describe-regions --region ap-northeast-2 --query 'Regions[*].RegionName' --output text);
#REGIONS="us-east-1 us-west-2 eu-west-1 ap-southeast-2 ap-northeast-1"
TOTAL=0

for REGION in $REGIONS
do
  while read ACCOUNT ACCESSKEY SECRETKEY
  do
    export AWS_ACCESS_KEY_ID=$ACCESSKEY
    export AWS_SECRET_ACCESS_KEY=$SECRETKEY

      echo $ACCOUNT $REGION "EC2" $(aws ec2 describe-instances --region $REGION --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value | [0],State.Name,InstanceId]' --output text | wc -l)
      echo $ACCOUNT $REGION "DynamoDB" $(aws dynamodb list-tables --region $REGION --output text | wc -l)
      echo $ACCOUNT $REGION "APIGateway" $(aws apigateway get-rest-apis --region $REGION --query 'items[*].[id,name]' --output text | wc -l)
      echo $ACCOUNT $REGION "ElasticSearch" $(aws es list-domain-names --region $REGION --query 'DomainNames[*].[DomainName]' --output text | wc -l)
      if [ $REGION = "eu-west-1" -o $REGION = "ap-southeast-1" -o $REGION = "ap-southeast-2" -o $REGION = "eu-central-1" -o $REGION = "ap-northeast-1" -o\
           $REGION = "us-east-1" -o $REGION = "us-west-2" -o $REGION = "us-west-1" -o $REGION = "us-west-2" ]; then
        echo $ACCOUNT $REGION "Firehose" $(aws firehose list-delivery-streams --region $REGION --query '[DeliveryStreamNames]' --output text | wc -l)
      fi
      echo $ACCOUNT $REGION "Lambda" $(aws lambda list-functions --region $REGION --query 'Functions[*].[FunctionName]' --output text | wc -l)
      echo $ACCOUNT $REGION "SNS" $(aws sns list-topics --region $REGION --query 'Topics[*].[TopicArn]' --output text | wc -l)
      if [ $REGION = "eu-west-1" -o $REGION = "us-east-1" -o $REGION = "us-west-2" ]; then
        echo $ACCOUNT $REGION "SES" $(aws ses list-identities --region $REGION --output text | wc -l)
      fi
      echo $ACCOUNT $REGION "SQS" $(aws sqs list-queues --region $REGION --output text | wc -l)
      if [ $REGION = "eu-west-1" -o $REGION = "ap-southeast-2" -o $REGION = "ap-northeast-1" -o $REGION = "us-east-1" -o $REGION = "us-west-2" ]; then
        echo $ACCOUNT $REGION "DataPipeline" $(aws datapipeline list-pipelines --region $REGION --query 'pipelineIdList[*].[id]' --output text | wc -l)
      fi
      echo $ACCOUNT $REGION "EMR" $(aws emr list-clusters --region $REGION --active --query 'Clusters[*].[Id]' --output text | wc -l)
      #echo $ACCOUNT "s3" $(aws s3 ls --region $REGION | wc -l)
    done < readonly_key_list
done