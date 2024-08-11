# Configure the AWS provider
provider "aws" {
  region = var.region
}


# Create an S3 bucket to store the web application code
resource "aws_s3_bucket" "web_app_bucket" {
  bucket = "simple-web-app-bucket-2024"
}

resource "aws_s3_bucket_ownership_controls" "s3" {
  bucket = aws_s3_bucket.web_app_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket = aws_s3_bucket.web_app_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3,
    aws_s3_bucket_public_access_block.s3,
  ]

  bucket = aws_s3_bucket.web_app_bucket.id
  acl    = "public-read-write"
}

# Upload the web application code to the S3 bucket
resource "aws_s3_object" "web_app_code" {
  bucket = aws_s3_bucket.web_app_bucket.id
  key    = "web.zip"
  source = "./code_app/web.zip"
  acl    = "public-read"
  depends_on = [
    aws_s3_bucket.web_app_bucket,
    aws_s3_bucket_acl.bucket
  ]
}



