import json
import boto3
import base64
import re
import urllib.parse


SLACK_BOT_TOKEN = ['@@@@@@@@@@@@@@@@@@']
VALID_CHANNELS = ['front-desk']
AVAILABLE_SERVICES = ['nginx', 'jenkins']

def convert_request(event):
    regex = re.compile('(?P<key>[^\=]+)\=(?P<value>[^\=]+)')
    
    body = {}
    decoded = base64.b64decode(event['body']).decode('utf-8')
    for d in decoded.split('&'):
        matched = regex.match(d)
        if matched is not None:
            body[matched['key']] = urllib.parse.unquote(matched['value'])
    
    event['body'] = body
    
    return event

def check_token(token):
    if token in SLACK_BOT_TOKEN:
        return True
    else:
        return False
        
def check_channel(channel):
    if channel in VALID_CHANNELS:
        return True
    else:
        return False

def check_ip(result):
    cnt = 0
    
    for i in range(2, len(result.groups()) + 1):
        if int(result.group(i)) > 255:
            cnt += 1
    
    if cnt == 0:
        return True
    else:
        return False

def check_command(command):
    pattern = re.compile(r'^([a-zA-Z]+)[\+]+([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$')

    result = pattern.match(command)

    response = {}
    
    if result is None or len(result.groups()) != 5:
        response['status'] = False
        response['message'] = 'Invalid slash command syntax.\nPlease enter `/opensesame help`'
        return response
    
    if not result.group(1) in AVAILABLE_SERVICES:
        response['status'] = False
        response['message'] = 'Currently, nginx and jenkins service is only available.'
        return response
    
    if not check_ip(result):
        response['status'] = False
        response['message'] = 'The Public IP is invalid. e.g., 82.100.52.99'
        return response
    
    response['status'] = True
    return response
    
def slack_message(text):
    return {
        'response_type': 'in_channel',
        'text': text
    }

def handler(event, context):
    event = convert_request(event)
    print(event)
    
    body = event['body']
    
    # invalid slack bot
    if not check_token(body['token']):
        return slack_message('Check the Slack Token...\nFailed Authentication\nPlease Check the Slash Command App Setting')
        
    # invalid slack channel
    if not check_channel(body['channel_name']): 
        return slack_message('The specific channel could access "/opensesame" command.\nPlease Check a Channel.')
    
    # help command
    if body['text'] == "help": 
        return slack_message('This is a function to access to bastion.\n- In korean, "Open sesame" is "열려라 참깨".\n- it adds ip address to bastion security group.\n- *Currently, nginx and jenkins service is available.*\n\nType `/opensesame [SERVICE] [IP]`')
    
    # invalid command
    report = check_command(body['text'])
    if not report['status']:
         return slack_message(report['message'])
    
    # valid command
    client = boto3.client('lambda')
    client.invoke_async(
        FunctionName='media-platform-front-desk-main-fn',
        InvokeArgs=json.dumps(event)
    )
    
    return slack_message('Check the Slack Token...\nSuccess Authentication!\n\nIt takes few seconds to process...')