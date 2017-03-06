resource "aws_db_instance" "vault_db" {
  allocated_storage      = 5
  engine                 = "postgresql"
  engine_version         = "9.6.1"
  instance_class         = "db.t1.micro"
  name                   = "vault"
  username               = "vault"
  password               = "${var.vault_password}"
  vpc_security_group_ids = ["${aws_security_group.vault-access.id}"]
}
