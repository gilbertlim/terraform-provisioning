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

def add_ingress(service_and_ip):
    pattern = re.compile(r'^([a-zA-Z]+)[\+]+([0-9\.]+)$')
    result = pattern.match(service_and_ip)
    
    security_group_id = SECURITY_GROUP_ID[result.group(1)]
    port = PORT[result.group(1)]
    ip = result.group(2)
    
    ec2 = boto3.client('ec2')

    try:
        result = ec2.authorize_security_group_ingress(
            GroupId = security_group_id,
            IpPermissions = [
                {
                    'IpProtocol': 'tcp',
                    'FromPort': port,
                    'ToPort': port,
                    'IpRanges': [
                        {
                            'CidrIp': ip + '/32'
                        }
                    ]
                }
            ]
        )
        print('Ingress Successfully Set %s' % result)
        
        return result
        
    except ClientError as e:
        print(e)

def slack_message(text):
    return {
        'response_type': 'in_channel',
        'text': text
    }

def handler(event, context):
    print(event)
    
    body = event['body']
    result = add_ingress(body['text'])

    if result is not None:
        data = slack_message('Successfully Done!' + ' ```' + str(result) + '```')
    else:
        data = slack_message('The IP is already added to bastion security group.')
    
    requests.post(WEBHOOK_URL, headers = HEADERS, data = json.dumps(data))