resource "aws_security_group" "vault-access" {
  description = "Access to Vault"
  name        = "Vault Access"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 8200
    to_port     = 8200
    protocol    = "TCP"
    cidr_blocks = ["${var.permitted_cidrs}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["${var.permitted_cidrs}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vault-db-access" {
  description = "Access to Vault DB"
  name        = "Vault DB Access"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "TCP"
    security_groups = ["${aws_security_group.vault-access.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
