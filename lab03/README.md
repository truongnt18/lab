

Run following step:
  1. Create necessery IAM Role name export-rds-to-s3-role with policy: 
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject*",
                "s3:ListBucket",
                "s3:GetObject*",
                "s3:DeleteObject*",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::demo-s3-bucket-creation-2024",
                "arn:aws:s3:::demo-s3-bucket-creation-2024/*"
            ]
        }
    ]
  }
  2. Create KMS key for store Backup RDS in S3: 
  3. S3 Bucket for store Backup RDS: 
  4.  install the `boto3` and `schedule` libraries
        pip3 install boto3 schedule
  5.  Run Script python snapshotRDS.py: 
          python3 snapshotRDS.py 

   