import boto3
import paramiko

def ssh_handler(event, context):

    client = boto3.client('ec2')
    s3_client = boto3.resource('s3')
    s3 = boto3.resource('s3')

    #Download private key file from secure S3 bucket
    s3.meta.client.download_file('csy-test-bucket','keys/CSY-EC2-TEST.pem', '/tmp/CSY-EC2-TEST.pem')

    filters = [{'Name':'tag:Environment','Values':['Dev']}]

    instances = client.describe_instances(Filters=filters)

    k = paramiko.RSAKey.from_private_key_file("/tmp/CSY-EC2-TEST.pem")
    c = paramiko.SSHClient()
    c.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    hostList = []

    for host in instances['Reservations']:
        for inst in host['Instances']:
            hostList.append(inst['PrivateIpAddress'])

    for host in hostList:
        print ("Connecting to " + host)
        c.connect( hostname = host, username = "ubuntu", pkey = k )
        print ("Connected to " + host)
        commands = [
            "sudo netstat -anptu | grep pdns",
            "sudo ps aux | grep pdns | grep -v grep",
            "sudo tail -30 /var/log/syslog"
            ]
        for command in commands:
            print ("Executing [$ {}]".format(command))
            stdin , stdout, stderr = c.exec_command(command)
            print ("".join(stdout.readlines()))
            print ("".join(stderr.readlines()))
