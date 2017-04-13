resource "aws_route53_record" "ops_manager" {
  name    = "pcf.${var.env_name}.${var.dns_suffix}"
  zone_id = "${var.zone_id}"
  type    = "A"
  ttl     = 300
  count   = "${var.count}"

  records = ["${aws_eip.ops_manager.public_ip}"]
}

resource "aws_route53_record" "upgrade_ops_manager" {
  name    = "pcf-upgrade.${var.env_name}.${var.dns_suffix}"
  zone_id = "${var.zone_id}"
  type    = "A"
  ttl     = 300
  count   = "${var.upgrade_count}"

  records = ["${aws_eip.upgrade_ops_manager.public_ip}"]
}
