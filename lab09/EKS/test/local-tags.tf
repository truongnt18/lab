locals {
  common_tags = {
     "Owner" = "CTO",
     "Environment" = var.env
     "ManagedBy" = "Terraform"
     "BusinessUnit" = "PWB" 
  }
}
