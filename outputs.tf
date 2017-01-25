output "ops_manager_bucket" {
  value = "${aws_s3_bucket.ops_manager_bucket.arn}"
}

output "ert_buildpacks_bucket" {
  value = "${aws_s3_bucket.buildpacks_bucket.arn}"
}

output "ert_droplets_bucket" {
  value = "${aws_s3_bucket.droplets_bucket.arn}"
}

output "ert_packages_bucket" {
  value = "${aws_s3_bucket.packages_bucket.arn}"
}

output "ert_resources_bucket" {
  value = "${aws_s3_bucket.resources_bucket.arn}"
}

output "ops_manager_public_ip" {
  value = "${aws_eip.ops_manager.public_ip}"
}

output "ops_manager_dns" {
  value = "${aws_route53_record.ops_manager.name}"
}

output "optional_ops_manager_dns" {
  value = "${aws_route53_record.optional_ops_manager.name}"
}

output "env_dns_zone_name_servers" {
  value = "${aws_route53_zone.pcf_zone.name_servers}"
}

output "sys_domain" {
  value = "sys.${var.env_name}.${var.dns_suffix}"
}

output "apps_domain" {
  value = "apps.${var.env_name}.${var.dns_suffix}"
}

output "tcp_domain" {
  value = "tcp.${var.env_name}.${var.dns_suffix}"
}

output "iam_user_name" {
  value = "${aws_iam_user.iam_user.name}"
}

output "iam_user_access_key" {
  value = "${aws_iam_access_key.iam_user_access_key.id}"
}

output "iam_user_secret_access_key" {
  value = "${aws_iam_access_key.iam_user_access_key.secret}"
}

output "rds_address" {
  value = "${aws_db_instance.rds.address}"
}

output "rds_port" {
  value = "${aws_db_instance.rds.port}"
}

output "rds_username" {
  value = "${aws_db_instance.rds.username}"
}

output "rds_password" {
  value = "${aws_db_instance.rds.password}"
}

output "ops_manager_security_group_id" {
  value = "${aws_security_group.ops_manager_security_group.id}"
}

output "vms_security_group_id" {
  value = "${aws_security_group.vms_security_group.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnets.*.id}"]
}

output "public_subnet_availability_zones" {
  value = ["${aws_subnet.public_subnets.*.availability_zone}"]
}

output "public_subnet_cidrs" {
  value = ["${aws_subnet.public_subnets.*.cidr_block}"]
}

output "management_subnet_ids" {
  value = ["${aws_subnet.management_subnets.*.id}"]
}

output "management_subnet_availability_zones" {
  value = ["${aws_subnet.management_subnets.*.availability_zone}"]
}

output "management_subnet_cidrs" {
  value = ["${aws_subnet.management_subnets.*.cidr_block}"]
}

output "ert_subnet_ids" {
  value = ["${aws_subnet.ert_subnets.*.id}"]
}

output "ert_subnet_availability_zones" {
  value = ["${aws_subnet.ert_subnets.*.availability_zone}"]
}

output "ert_subnet_cidrs" {
  value = ["${aws_subnet.ert_subnets.*.cidr_block}"]
}

output "services_subnet_ids" {
  value = ["${aws_subnet.services_subnets.*.id}"]
}

output "services_subnet_availability_zones" {
  value = ["${aws_subnet.services_subnets.*.availability_zone}"]
}

output "services_subnet_cidrs" {
  value = ["${aws_subnet.services_subnets.*.cidr_block}"]
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "ops_manager_ssh_private_key" {
  value = "${tls_private_key.ops_manager.private_key_pem}"
}

output "ops_manager_ssh_public_key_name" {
  value = "${aws_key_pair.ops_manager.key_name}"
}

output "region" {
  value = "${var.region}"
}

output "azs" {
  value = "${var.availability_zones}"
}
