import boto3
import datetime
import schedule
import time


instance_id = 'database-1'
IamRole_export='arn:aws:iam::150455926741:role/export-rds-to-s3-role'
Kms_export='arn:aws:kms:ap-southeast-1:150455926741:key/8113fe03-afe6-41ad-8c7b-88e40eb1be8a'
t = datetime.datetime.now().strftime("%Y-%m-%d")
name_export_time = instance_id +'-'+ t
S3_Bucket_snapshot='demo-s3-bucket-creation-2024'
s3_prefix = 'database-1/'+ name_export_time
export_identifier='export-'+ name_export_time

client = boto3.client('rds', region_name='ap-southeast-1')


def create_rds_backup(instance_id):
  
    # Create a auto backup of the RDS instance
    backup_name = f'{instance_id}-backup-{datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")}'
    response = client.create_db_snapshot(DBSnapshotIdentifier=backup_name, DBInstanceIdentifier=instance_id)
    
    print(f"Created backup with snapshot name: {backup_name}")

def export_snapshot_to_s3(instance_id):

    response = client.describe_db_snapshots(
        DBInstanceIdentifier=instance_id,
        IncludePublic=False,
        IncludeShared=True,
        SnapshotType='manual',
    )
    list_rds_snapshot=[]
    for rds_snapshot in response['DBSnapshots']:
        list_rds_snapshot.append(rds_snapshot['DBSnapshotArn'])
    number = len(list_rds_snapshot)
    snapshot_new = list_rds_snapshot[number-1]  # get snapshot newest

    # export snapshot to s3
    response_export = client.start_export_task(
        ExportTaskIdentifier=export_identifier,
        SourceArn=snapshot_new,    #test_rds,          
        S3BucketName=S3_Bucket_snapshot,
        IamRoleArn=IamRole_export,
        KmsKeyId=Kms_export,
        S3Prefix=s3_prefix,
    )
    print (response_export)


    


# Schedule the backup job to run daily at 17:00
schedule.every().day.at("17:00").do(create_rds_backup, instance_id)

# Schedule export snapshot RDS to S3 run daily ad 17:10
schedule.every().day.at("17:10").do(export_snapshot_to_s3, instance_id)

while True:
    schedule.run_pending()
    time.sleep(1)