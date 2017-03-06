resource "aws_db_instance" "vault_db" {
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "9.6.1"
  instance_class         = "db.t2.micro"
  name                   = "vault"
  username               = "vault"
  password               = "${var.vault_password}"
  vpc_security_group_ids = ["${aws_security_group.vault-db-access.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.vault.name}"
}

resource "aws_db_subnet_group" "vault" {
  name       = "vault"
  subnet_ids = ["${var.subnets}"]

  tags {
    Name = "Vault DB subnet group"
  }
}
