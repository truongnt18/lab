#!/bin/bash
 
# Set the AWS region
AWS_REGION="ap-southeast-1"
 
# Set the CloudWatch alarm name
ALARM_NAME="CPUUtilization"
 
# Set the SNS topic ARN
SNS_TOPIC_ARN="arn:aws:sns:ap-southeast-1:150455926741:alarm-cpu-topic"
 
# Continuously monitor the alarm state
while true; do
    # Get the current state of the alarm
    alarm_state=$(aws cloudwatch describe-alarms --alarm-names "$ALARM_NAME" --query 'MetricAlarms[0].StateValue' --output text --region "$AWS_REGION")
 
    # Check if the alarm is in the ALARM state
    if [ "$alarm_state" == "ALARM" ]; then
        # Send a notification to the SNS topic
        aws sns publish --topic-arn "$SNS_TOPIC_ARN" --message "Alarm $ALARM_NAME has been triggered" --region "$AWS_REGION"
        echo "Notification sent to SNS topic"
    fi
 
    # Wait for 60 seconds before checking the alarm state again
    sleep 60
done