resource "aws_instance" "vault" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"

  subnet_id              = "${element( var.subnets, count.index % length(var.subnets))}"
  vpc_security_group_ids = ["${aws_security_group.vault-access.id}"]
  count                  = "${var.ha ? 2 : 1}"

  tags {
    Name   = "vault${var.ha ? format("-%02d", count.index + 1): ""}"
    Domain = "${var.domain}"
    Role   = "Vault Server"
  }

  iam_instance_profile = "${var.instance_profile_id}"
  user_data            = "${module.vault_bootstrap.cloud_init_config}"
}

# variable "ansible_facts" {
#   type = "map"

#   default = {
#     vault_ha = "${var.ha}"
#   }
# }

module "vault_bootstrap" {
  source              = "git@github.com:serene-wozniak/terraform-module-bootstrap.git//ansible_bootstrap?ref=ansible-facts"
  ansible_source_repo = "git@github.com:serene-wozniak/terraform-module-vault.git"
  ansible_role        = "vault"

  ansible_facts = {
    vault_ha = "${var.ha}"
  }

  ssh_ca_publickey      = "${var.ssh_user_ca_publickey}"
  github_ssh_privatekey = "${var.git_private_key}"
}