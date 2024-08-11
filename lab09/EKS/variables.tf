#
# Variables Configuration
#
variable "eks_version" {
  default = "1.30"
}
variable "vpc_id" {}
variable "account_name" {}
variable "node_group_name" {}
variable "ssh_key" {}
variable "project-name" {}
variable "env" {}
#variable "subnet_ids" { type = list }
#variable "private_subnet_ids" { type = list }
#variable "cidr_block" {}

#variable "pub1a_cidr_block" {}
#variable "map_public_ip" {
#  default = "true"
#  type = bool
#}
#variable "pub1b_cidr_block" {}
#variable "pub1c_cidr_block" {}
#variable "priv1a_cidr_block" {}
#variable "priv1b_cidr_block" {}
#variable "priv1c_cidr_block" {}
