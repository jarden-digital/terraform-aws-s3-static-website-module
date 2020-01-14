locals {
  bucket_name         = "${format("%s.%s", var.site_name, var.site_namespace)}"
  logging_bucket_name = "${format("%s-%s", local.bucket_name, "site-logs")}"
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

  versioning {
    enabled = "${var.enable_bucket_object_versioning}"
  }

  logging {
    target_bucket = "${aws_s3_bucket.static_website_log_bucket.id}"
    target_prefix = "${var.site_name}/"
  }
}

resource "aws_s3_bucket" "static_website_log_bucket" {
  bucket = "${local.logging_bucket_name}"
  acl    = "log-delivery-write"

   versioning {
    enabled = "${var.enable_bucket_object_versioning}"
  }
}

resource "aws_s3_bucket_object" "config_file" {
  key     = "config.json"
  bucket  = "${aws_s3_bucket.static_website.id}"
  content = "${jsonencode(var.site_config_values)}"
  acl     = "public-read"
}
