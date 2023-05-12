import json
import base64
import re
import boto3
from botocore.exceptions import ClientError
import urllib.parse
import requests


WEBHOOK_URL = 'https://hooks.slack.com/services/ABCDEF/ABCDEFG/ABCDEFG'
HEADERS = {'Content-Type': 'application/json' }

# aws
SECURITY_GROUP_ID = {
    'nginx' : 'sg-0e1ca2bcc9f488062',
    'jenkins' : 'sg-067e9fc8de71ad524'
}

PORT = {
    'nginx' : 5299,
    'jenkins' : 80
}

def revoke_ingress_all():
    ec2 = boto3.resource('ec2')
    
    try:
        for service in SECURITY_GROUP_ID.keys():
            security_group_id = SECURITY_GROUP_ID[service]
            
            security_group = ec2.SecurityGroup(security_group_id)
            print('[{0}] security_group.ip_permissions: {1}' .format(service, security_group.ip_permissions))
        
            if len(security_group.ip_permissions) != 0:
                security_group.revoke_ingress(
                    GroupId = security_group_id,
                    IpPermissions=security_group.ip_permissions
                )
                print('[{0}] Completed to revoke Ingress rules.' .format(service))
            else:
                print('No ingress rules')
    except ClientError as e:
        print(e)

def initialize_ingress():
    ec2 = boto3.client('ec2')
    
    try:
        for service in SECURITY_GROUP_ID.keys():
            security_group_id = SECURITY_GROUP_ID[service]
            port = PORT[service]
            
            result = ec2.authorize_security_group_ingress(
                GroupId = security_group_id,
                IpPermissions = [
                    {
                        'IpProtocol': 'tcp',
                        'FromPort': port,
                        'ToPort': port,
                        'IpRanges': [
                            {
                                'CidrIp': '123.456.789.33/32',
                                'Description': 'building'
                            },
                            {
                                'CidrIp': '123.456.789.34/32',
                                'Description': 'building'
                            }
                        ]
                    }
                ]
            )
            print('[{0}] Ingress Successfully Set {1}' .format(service, result))
    except ClientError as e:
        print(e)

def slack_message(text):
    return {
        'response_type': 'in_channel',
        'text': text
    }

def handler(event, context):
    print(event)
    
    revoke_ingress_all()
    initialize_ingress()
    
    data = slack_message('Good morning!\nCompleted to reset Ingress rules.')
    requests.post(WEBHOOK_URL, headers = HEADERS, data = json.dumps(data))