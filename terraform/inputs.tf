variable "subnets" {
  type = "list"
}

variable "vpc_id" {}
variable "ami" {}
variable "instance_type" {}
variable "domain" {}
variable "instance_profile_id" {}

variable "vault_password" {}
variable "route53_zone_id" {}
variable "route53_domain" {}

variable "permitted_cidrs" {
  type = "list"
}

variable "ha" {
  type = "string"
}

# Config Management
variable "ssh_user_ca_publickey" {}
variable "git_private_key" {}
variable "consul_encryption_key" {}
