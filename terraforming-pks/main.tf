provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

terraform {
  required_version = "< 0.12.0"
}

locals {
  ops_man_subnet_id = "${var.ops_manager_private ? element(module.infra.infrastructure_subnet_ids, 0) : element(module.infra.public_subnet_ids, 0)}"

  bucket_suffix = "${random_integer.bucket.result}"

  default_tags = {
    Environment = "${var.env_name}"
    Application = "Cloud Foundry"
  }

  actual_tags = "${merge(var.tags, local.default_tags)}"

  use_route53 = "${var.region != "us-gov-west-1" ? var.use_route53 : false}"
}

resource "random_integer" "bucket" {
  min = 1
  max = 100000
}

module "infra" {
  source             = "../modules/infra"

  region             = "${var.region}"
  env_name           = "${var.env_name}"
  availability_zones = "${var.availability_zones}"
  vpc_cidr           = "${var.vpc_cidr}"

  hosted_zone        = "${var.hosted_zone}"
  dns_suffix         = "${var.dns_suffix}"
  use_route53        = "${local.use_route53}"

  tags               = "${local.actual_tags}"
}

module "ops_manager" {
  source = "../modules/ops_manager"

  count                     = "${var.ops_manager ? 1 : 0}"
  optional_count            = "${var.optional_ops_manager ? 1 : 0}"
  subnet_id                 = "${local.ops_man_subnet_id}"

  env_name                  = "${var.env_name}"
  ami                       = "${var.ops_manager_ami}"
  optional_ami              = "${var.optional_ops_manager_ami}"
  instance_type             = "${var.ops_manager_instance_type}"
  private                   = "${var.ops_manager_private}"
  vpc_id                    = "${module.infra.vpc_id}"
  vpc_cidr                  = "${var.vpc_cidr}"
  dns_suffix                = "${var.dns_suffix}"
  zone_id                   = "${module.infra.zone_id}"
  bucket_suffix             = "${local.bucket_suffix}"
  use_route53               = "${local.use_route53}"

  tags                      = "${local.actual_tags}"
}

module "certs" {
  source = "../modules/certs"

  subdomains          = ["*.pks"]
  env_name            = "${var.env_name}"
  dns_suffix          = "${var.dns_suffix}"

  ssl_cert            = "${var.ssl_cert}"
  ssl_private_key     = "${var.ssl_private_key}"
  ssl_ca_cert         = "${var.ssl_ca_cert}"
  ssl_ca_private_key  = "${var.ssl_ca_private_key}"
}

module "pks" {
  source = "../modules/pks"

  env_name                     = "${var.env_name}"
  availability_zones           = "${var.availability_zones}"
  vpc_cidr                     = "${var.vpc_cidr}"
  vpc_id                       = "${module.infra.vpc_id}"
  private_route_table_ids      = "${module.infra.private_route_table_ids}"
  public_subnet_ids            = "${module.infra.public_subnet_ids}"

  zone_id                      = "${module.infra.zone_id}"
  dns_suffix                   = "${var.dns_suffix}"
  use_route53                  = "${local.use_route53}"

  tags                         = "${local.actual_tags}"
}

module "rds" {
  source = "../modules/rds"

  rds_db_username    = "${var.rds_db_username}"
  rds_instance_class = "${var.rds_instance_class}"
  rds_instance_count = "${var.rds_instance_count}"

  env_name           = "${var.env_name}"
  availability_zones = "${var.availability_zones}"
  vpc_cidr           = "${var.vpc_cidr}"
  vpc_id             = "${module.infra.vpc_id}"

  tags               = "${local.actual_tags}"
}
