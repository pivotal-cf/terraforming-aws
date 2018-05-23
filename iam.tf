resource "aws_iam_user" "ops_manager" {
  name = "${var.env_name}_om_user"
}

resource "aws_iam_access_key" "ops_manager" {
  user = "${aws_iam_user.ops_manager.name}"
}

resource "aws_iam_instance_profile" "ops_manager" {
  name = "${var.env_name}_ops_manager"
  role = "${aws_iam_role.ops_manager.name}"

  lifecycle {
    ignore_changes = ["name"]
  }
}

resource "aws_iam_role" "ops_manager" {
  name = "${var.env_name}_om_role"

  lifecycle {
    create_before_destroy = true
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
EOF
}

data "template_file" "ert" {
  template = "${file("${path.module}/templates/iam_pas_buckets_policy.json")}"

  vars {
    buildpacks_bucket_arn = "${aws_s3_bucket.buildpacks_bucket.arn}"
    droplets_bucket_arn   = "${aws_s3_bucket.droplets_bucket.arn}"
    packages_bucket_arn   = "${aws_s3_bucket.packages_bucket.arn}"
    resources_bucket_arn  = "${aws_s3_bucket.resources_bucket.arn}"
    kms_key_arn           = "${aws_kms_key.blobstore_kms_key.arn}"
  }
}

resource "aws_iam_policy" "ert" {
  name   = "${var.env_name}_ert"
  policy = "${data.template_file.ert.rendered}"
}

resource "aws_iam_role_policy_attachment" "pas" {
  role       = "${var.env_name}_om_role"
  policy_arn = "${aws_iam_policy.ert.arn}"
}

resource "aws_iam_role" "pas_bucket_access" {
  name = "${var.env_name}_pas_bucket_access"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "pas_bucket_access" {
  name = "${var.env_name}_pas_bucket_access"
  role = "${aws_iam_role.pas_bucket_access.id}"

  policy = "${data.template_file.ert.rendered}"
}

resource "aws_iam_user_policy_attachment" "ert" {
  user       = "${aws_iam_user.ops_manager.name}"
  policy_arn = "${aws_iam_policy.ert.arn}"
}

resource "aws_iam_instance_profile" "pas_bucket_access" {
  name = "${var.env_name}_pas_bucket_access"
  role = "${aws_iam_role.pas_bucket_access.name}"
}

data "template_file" "pas_backup_bucket_policy" {
  template = "${file("${path.module}/templates/iam_pas_backup_buckets_policy.json")}"

  vars {
    buildpacks_backup_bucket_arn = "${aws_s3_bucket.buildpacks_backup_bucket.arn}"
    droplets_backup_bucket_arn   = "${aws_s3_bucket.droplets_backup_bucket.arn}"
    packages_backup_bucket_arn   = "${aws_s3_bucket.packages_backup_bucket.arn}"
    resources_backup_bucket_arn  = "${aws_s3_bucket.resources_backup_bucket.arn}"
  }

  count = "${var.create_backup_pas_buckets ? 1 : 0}"
}

resource "aws_iam_policy" "pas_backup_bucket_policy" {
  name   = "${var.env_name}_pas_backup_bucket_policy"
  policy = "${data.template_file.pas_backup_bucket_policy.rendered}"
}

resource "aws_iam_role_policy" "pas_backup_bucket_access" {
  name   = "${var.env_name}_pas_backup_bucket_access"
  role   = "${aws_iam_role.pas_bucket_access.id}"
  policy = "${data.template_file.pas_backup_bucket_policy.rendered}"

  count = "${var.create_backup_pas_buckets ? 1 : 0}"
}

resource "aws_iam_user_policy_attachment" "pas_backup_bucket_access" {
  user       = "${aws_iam_user.ops_manager.name}"
  policy_arn = "${aws_iam_policy.pas_backup_bucket_policy.arn}"
}
