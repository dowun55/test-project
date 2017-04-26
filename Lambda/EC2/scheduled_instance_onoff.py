import boto3

def lambda_handler(event, context):

    ec2 = boto3.resource('ec2')
    filters = [{
            'Name': 'tag:CsyAutoStop',
            'Values': ['True']
        },
        {
            'Name': 'instance-state-name',
            'Values': ['running']
        }
    ]
    instances = ec2.instances.filter(Filters=filters)
    RunningInstances = [instance.id for instance in instances]
    if len(RunningInstances) > 0:
        shuttingDown = ec2.instances.filter(InstanceIds=RunningInstances).stop()
        print shuttingDown
    else:
        print "CSY Error!!!"
