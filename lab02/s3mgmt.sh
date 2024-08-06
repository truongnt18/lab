#!/bin/bash

# Set your AWS region
AWS_REGION="ap-southeast-1"


create_new_bucket() {
  local BUCKET_NAME=$1
  
  aws s3api create-bucket --bucket $BUCKET_NAME  --region $AWS_REGION --create-bucket-configuration LocationConstraint=$AWS_REGION

  # Check the exit status of the previous command
  if [ $? -eq 0 ]; then
     echo "Bucket $BUCKET_NAME created successfully."
  else
      echo "Failed to create bucket $BUCKET_NAME."
  fi
}

upload_to_bucket() {
 local BUCKET_NAME=$1  # "your-unique-bucket-name"
 local LOCAL_FILE_PATH=$2 # path/to/your/local/file.txt

 # Upload the local file to the S3 bucket
 aws s3 cp $LOCAL_FILE_PATH s3://$BUCKET_NAME/

  # Check the exit status of the previous command
  if [ $? -eq 0 ]; then
     echo "File $LOCAL_FILE_PATH uploaded to bucket $BUCKET_NAME successfully."
  else
      echo "Failed to upload file $LOCAL_FILE_PATH to bucket $BUCKET_NAME."
  fi
}

download_from_bucket() {
 local BUCKET_NAME=$1  # "your-unique-bucket-name"
 local LOCAL_DIR_PATH=$2 # 
 local OBJECT_KEY=$3

 # Download the object from the S3 bucket to the local directory
  aws s3 cp s3://$BUCKET_NAME/$OBJECT_KEY $LOCAL_DIR_PATH

  # Check the exit status of the previous command
  if [ $? -eq 0 ]; then
     echo "Object $OBJECT_KEY downloaded from bucket $BUCKET_NAME to $LOCAL_DIR_PATH successfully."
  else
     echo "Failed to download object $OBJECT_KEY from bucket $BUCKET_NAME."
  fi
}

delete_object() {
 local BUCKET_NAME=$1  # "your-unique-bucket-name"
 local OBJECT_KEY=$2   # path/to/your/object/file.txt"

  # Delete the object from the S3 bucket
  aws s3 rm s3://$BUCKET_NAME/$OBJECT_KEY

  # Check the exit status of the previous command
  if [ $? -eq 0 ]; then
     echo "Object $OBJECT_KEY deleted from bucket $BUCKET_NAME successfully."
  else
      echo "Failed to delete object $OBJECT_KEY from bucket $BUCKET_NAME."
  fi
}


ACTION=$1  # CREATE, UPLOAD, DOWNLOAD, DELETE


if [[ -z "${ACTION}"  ]] ; then
  echo "Needs environment"
  exit 1
fi

if [[ $ACTION == "CREATE" || $ACTION == "UPLOAD" || $ACTION == "DOWNLOAD" || $ACTION == "DELETE" ]] ; then
    echo "ACTION = " $ACTION  "  "  $BUCKET_NAME
    if [[ $ACTION == "CREATE" ]] ; then
      BUCKET_NAME=$2  # create-s3-bucket-demo-2024
      LOCAL_FILE_PATH=$3  # path/to/your/local/file.txt
      OBJECT_KEY=$4 
      echo "------- Start to CREATE new bucket name " $BUCKET_NAME " --------"
      create_new_bucket $BUCKET_NAME

    elif [[ $ACTION == "UPLOAD" ]] ; then
      BUCKET_NAME=$2  # create-s3-bucket-demo-2024
      LOCAL_FILE_PATH=$3  # path/to/your/local/file.txt
      echo "------- Start to UPLOAD  " $LOCAL_FILE_PATH " to " $BUCKET_NAME "--------"
      upload_to_bucket $BUCKET_NAME $LOCAL_FILE_PATH 
    elif [[ $ACTION == "DOWNLOAD" ]] ; then
      BUCKET_NAME=$2  # create-s3-bucket-demo-2024
      OBJECT_KEY=$3  # path/to/your/local/file.txt
      LOCAL_DIR_PATH=$4 
      echo "------- Start to DOWNLOAD  " $OBJECT_KEY " from " $BUCKET_NAME " to " $LOCAL_DIR_PATH " --------"
      download_from_bucket $BUCKET_NAME $LOCAL_DIR_PATH $OBJECT_KEY
    elif [[ $ACTION == "DELETE" ]] ; then
      BUCKET_NAME=$2  # create-s3-bucket-demo-2024
      OBJECT_KEY=$3  # path/to/your/local/file.txt
      echo "------- Start to DELETE  " $OBJECT_KEY " from " $BUCKET_NAME "  --------"
      delete_object $BUCKET_NAME $LOCAL_DIR_PATH $OBJECT_KEY
    fi

else
  echo "Wrong ACTION   !!!"
fi


