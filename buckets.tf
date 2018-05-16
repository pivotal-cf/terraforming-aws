resource "random_integer" "bucket" {
  min = 1
  max = 100000
}

locals {
  bucket_suffix = "${random_integer.bucket.result}"
}

resource "aws_s3_bucket" "buildpacks_bucket" {
  bucket        = "${var.env_name}-buildpacks-bucket-${local.bucket_suffix}"
  force_destroy = true

  versioning {
    enabled = "${var.create_versioned_pas_buckets}"
  }

  tags = "${merge(var.tags, local.default_tags,
    map("Name", "Elastic Runtime S3 Buildpacks Bucket")
  )}"
}

resource "aws_s3_bucket" "droplets_bucket" {
  bucket        = "${var.env_name}-droplets-bucket-${local.bucket_suffix}"
  force_destroy = true

  versioning {
    enabled = "${var.create_versioned_pas_buckets}"
  }

  tags = "${merge(var.tags, local.default_tags,
    map("Name", "Elastic Runtime S3 Droplets Bucket")
  )}"
}

resource "aws_s3_bucket" "packages_bucket" {
  bucket        = "${var.env_name}-packages-bucket-${local.bucket_suffix}"
  force_destroy = true

  versioning {
    enabled = "${var.create_versioned_pas_buckets}"
  }

  tags = "${merge(var.tags, local.default_tags,
    map("Name", "Elastic Runtime S3 Packages Bucket")
  )}"
}

resource "aws_s3_bucket" "resources_bucket" {
  bucket        = "${var.env_name}-resources-bucket-${local.bucket_suffix}"
  force_destroy = true

  versioning {
    enabled = "${var.create_versioned_pas_buckets}"
  }

  tags = "${merge(var.tags, local.default_tags,
    map("Name", "Elastic Runtime S3 Resources Bucket")
  )}"
}

resource "aws_kms_key" "blobstore_kms_key" {
  description             = "${var.env_name} KMS key"
  deletion_window_in_days = 7

  tags = "${merge(var.tags, local.default_tags,
    map("Name", "${var.env_name} Blobstore KMS Key")
  )}"
}

resource "aws_kms_alias" "blobstore_kms_key_alias" {
  name          = "alias/${var.env_name}"
  target_key_id = "${aws_kms_key.blobstore_kms_key.key_id}"
}

resource "aws_s3_bucket" "buildpacks_backup_bucket" {
  bucket        = "${var.env_name}-buildpacks-backup-bucket-${local.bucket_suffix}"
  force_destroy = true

  count = "${var.create_backup_pas_buckets ? 1 : 0}"

  tags = "${merge(var.tags, local.default_tags,
    map("Name", "Elastic Runtime S3 Buildpacks Backup Bucket")
  )}"
}

resource "aws_s3_bucket" "droplets_backup_bucket" {
  bucket        = "${var.env_name}-droplets-backup-bucket-${local.bucket_suffix}"
  force_destroy = true

  count = "${var.create_backup_pas_buckets ? 1 : 0}"

  tags = "${merge(var.tags, local.default_tags,
    map("Name", "Elastic Runtime S3 Droplets Backup Bucket")
  )}"
}

resource "aws_s3_bucket" "packages_backup_bucket" {
  bucket        = "${var.env_name}-packages-backup-bucket-${local.bucket_suffix}"
  force_destroy = true

  count = "${var.create_backup_pas_buckets ? 1 : 0}"

  tags = "${merge(var.tags, local.default_tags,
    map("Name", "Elastic Runtime S3 Packages Backup Bucket")
  )}"
}

resource "aws_s3_bucket" "resources_backup_bucket" {
  bucket        = "${var.env_name}-resources-backup-bucket-${local.bucket_suffix}"
  force_destroy = true

  count = "${var.create_backup_pas_buckets ? 1 : 0}"

  tags = "${merge(var.tags, local.default_tags,
    map("Name", "Elastic Runtime S3 Resources Backup Bucket")
  )}"
}
