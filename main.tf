locals {
  bucket_name         = "${format("%s.%s", var.site_name, var.namespace)}"
  logging_bucket_name = "${format("%s-%s.%s", var.site_name, "site-logs", var.namespace)}"
}

resource "aws_s3_bucket" "static_website" {
  bucket        = "${local.bucket_name}"
  acl           = "public-read"
  policy        = "${data.aws_iam_policy_document.s3_website_public_get.json}"
  force_destroy = true

  website {
    index_document = "${var.index_document_default}"
    error_document = "${var.error_document_default}"
  }

  cors_rule {
    allowed_origins = "${var.cors_allowed_origins}"
    allowed_methods = "${var.cors_allowed_methods}"
    allowed_headers = "${var.cors_allowed_headers}"
    expose_headers  = "${var.cors_expose_headers}"
    max_age_seconds = "${var.cors_max_age_seconds}"
  }

  logging {
    target_bucket = "${aws_s3_bucket.static_website_log_bucket.id}"
    target_prefix = "${var.site_name}/"
  }

  tags = "${merge(map("Name", local.bucket_name), map("Site Name", var.site_name), var.s3_tags, var.module_tags)}"
}

resource "aws_s3_bucket" "static_website_log_bucket" {
  bucket = "${local.logging_bucket_name}"
  acl    = "log-delivery-write"

  tags = "${merge(map("Name", local.logging_bucket_name), map("Site Name", var.site_name), var.s3_tags, var.module_tags)}"
}

resource "aws_s3_bucket_object" "config_file" {
  key     = "config.json"
  bucket  = "${aws_s3_bucket.static_website.id}"
  content = "${jsonencode(var.site_config_values)}"
  acl     = "public-read"

  tags = "${merge(map("Site Name", var.site_name), var.module_tags)}"
}
