terraform {
  required_version = ">= 0.12.0"

  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "tops-nonprod-2024-terraform-state"
    key            = "../backend-state/terraform.tfstate"
    region         = "ap-southeast-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "tops-nonprod-terraform-state-locks"
    encrypt        = true
  }
}

