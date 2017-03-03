provider "aws" {
  region = "eu-west-1"
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "a-state-bucket"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_ami" "centos_7" {
  most_recent = true

  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }
}

variable "ssh_user_ca_publickey" {}
variable "git_private_key_b64" {}

variable "permitted_cidrs" {
  type = "list"

  default = ["10.4.0.0/18",
    "10.31.0.0/18",
  ]
}

module "vault" {
  source = "../terraform-module-vault/terraform"

  # Networking
  vpc_id          = "${data.terraform_remote_state.network.vpc_id}"
  permitted_cidrs = "${var.permitted_cidrs}"

  subnets = ["${data.terraform_remote_state.network.public-subnet-a}",
    "${data.terraform_remote_state.network.public-subnet-b}",
  ]

  ha                    = true
  domain                = "example.com"
  ssh_user_ca_publickey = "${var.ssh_user_ca_publickey}"
  git_private_key       = "${base64decode(var.git_private_key_b64)}"

  #Machines
  instance_profile_id = "${data.terraform_remote_state.network.oc-instance-profile}"
  ami                 = "${data.aws_ami.centos_7.id}"
  instance_type       = "t2.micro"
}
