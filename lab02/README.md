

Run following step:
  1.  chmod +x s3mgmt.sh
  2.  Create new Bucket: 
          ./s3mgmt.sh CREATE  bucket-name
  3.  Upload object to bucket: 
           ./s3mgmt.sh UPLOAD bucket-name  local-file-path
  4.  Download object key from bucket:
           ./s3mgmt.sh DOWNLOAD bucket-name  object-key  local-path
  5.  Delete object key from bucket:
           ./s3mgmt.sh DELETE bucket-name  object-key  
   