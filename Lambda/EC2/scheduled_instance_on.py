import boto3
import sys

def lambda_handler(event, context):

    ec2 = boto3.resource('ec2')
    filters_running = [{
                'Name': 'tag:CsyAuto',
                'Values': ['True']
                }, {
                'Name': 'instance-state-name',
                'Values': ['running']
                }]

    instances = ec2.instances.filter(Filters=filters)

    if len([instance.id for instance in instances]) > 0:
        instanceId = [instance.id for instance in instances]
        instanceStop = ec2.instances.filter(InstanceIds=instanceId).stop()
        print (instanceStop)
    else:
        print("There is no running instances!!!")
