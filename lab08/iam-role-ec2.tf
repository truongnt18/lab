resource "aws_iam_role" "ec2_instance" {
  name = "ec2-iam-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
  ]

  inline_policy {
    name = "ec2_write_cw"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "cloudwatch:PutMetricData",
            "ec2:DescribeVolumes",
            "ec2:DescribeTags",
            "logs:PutLogEvents",
            "logs:DescribeLogStreams",
            "logs:DescribeLogGroups",
            "logs:PutRetentionPolicy",
            "logs:CreateLogStream"
          ],
          "Resource" : "*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup"
          ],
          "Resource" : "arn:aws:logs:*:*:log-group:*:log-stream:*"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameter"
          ],
          "Resource" : "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
        },
      ]
    })
  }

  inline_policy {
    name = "ec2_access_to_s3"

    policy = jsonencode({
      "Version" : "2012-10-17"
      "Statement" : [
        {
          "Action" : [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListAllMyBuckets",
            "s3:AbortMultipartUpload",
            "s3:ListBucket",
            "s3:GetBucketAcl",
            "s3:GetBucketLocation",
            "s3:ListMultipartUploadParts"
          ]
          "Effect" : "Allow"
          "Resource" : "arn:aws:s3:::*"

        },
      ]
    })
  }


}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-role"
  role = aws_iam_role.ec2_instance.name
}