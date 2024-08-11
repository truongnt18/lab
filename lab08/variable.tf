
variable "region" {
  description = "The region Terraform deploys your instances"
  type        = string
}

variable "solution_stack_name" {
  description = "solution stack name"
  type        = string
}

variable "instance_type_ec2" {
  description = "instance type of wordpress EC2"
  type        = string
}


