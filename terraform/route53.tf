resource "aws_route53_record" "vault" {
  zone_id = "${var.route53_zone_id}"
  count   = "${var.ha ? 2 : 1}"
  name    = "vault${var.ha ? format("-%02d", count.index + 1): ""}.${var.route53_domain}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.vault.*.private_ip, count.index)}"]
}
