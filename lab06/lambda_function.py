import boto3
from email.mime.text import MIMEText
 
# AWS SES client
ses = boto3.client('ses')
 
def lambda_handler(event, context):
    # Email details
    sender = 'nguyentruong18185@gmail.com'
    recipient = 'nacoi18@gmail.com'
    subject = 'Test Email'
    body = 'This is a test email sent from a Lambda function.'
 
    # Create the email message
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = sender
    msg['To'] = recipient
 
    # Send the email
    try:
        response = ses.send_raw_email(
            Source=sender,
            Destinations=[recipient],
            RawMessage={
                'Data': msg.as_string()
            }
        )
        print(f'Email sent. Message ID: {response["MessageId"]}')
    except Exception as e:
        print(f'Error sending email: {e}')
        raise e
 
    return {
        'statusCode': 200,
        'body': 'Email sent successfully'
    }
 