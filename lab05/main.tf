provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_sns_topic" "alarm_topic" {
  name         = "alarm-cpu-topic"
  display_name = "alarm-cpu-topic"
}


# EC2 instance with the IAM role attached
resource "aws_instance" "demo" {
  ami           = "ami-009c9406091cbd65a"
  instance_type = "t2.micro"

  #   iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "demoInstance"
  }
}



# CloudWatch metric alarm CPUUtilization
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors EC2 CPU utilization"


  dimensions = {
    InstanceId = aws_instance.demo.id
  }
}




# # IAM role for EC2 instance to publish CloudWatch metrics
# resource "aws_iam_role" "ec2_cloudwatch_role" {
#   name = "EC2CloudWatchRole"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# # IAM policy allowing EC2 to publish CloudWatch metrics
# resource "aws_iam_policy" "ec2_cloudwatch_policy" {
#   name = "EC2-CloudWatch-Policy"
#   description = "Allows EC2 instances to publish CloudWatch metrics"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Action = [
#         "cloudwatch:PutMetricData"
#       ]
#       Resource = "*"
#     }]
#   })
# }

# # Attach the policy to the role
# resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_attach" {
#   role       = aws_iam_role.ec2_cloudwatch_role.name
#   policy_arn = aws_iam_policy.ec2_cloudwatch_policy.arn
# }

# # Create Instance Profile
# resource "aws_iam_instance_profile" "ec2_instance_profile" {
#   name = "EC2-instance-role"
#   role = aws_iam_role.ec2_cloudwatch_role.name
# }
