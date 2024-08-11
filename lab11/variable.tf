
variable "region" {
  description = "The region Terraform deploys your instances"
  type        = string
}

variable "instance_type_db" {
  description = "instance type of db"
  type        = string
}

variable "instance_type_ec2" {
  description = "instance type of wordpress EC2"
  type        = string
}


