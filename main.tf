locals {
  bucket_name         = format("%s.%s", var.site_name, var.namespace)
  logging_bucket_name = format("%s-%s.%s", var.site_name, "site-logs", var.namespace)
}

resource "aws_s3_bucket" "static_website" {
  bucket        = local.bucket_name
  acl           = "public-read"
  policy        = data.aws_iam_policy_document.s3_website_public_get.json
  force_destroy = true

  //Set the website data block based on the redirect_url variable being set
  dynamic website {
    for_each = length(var.redirect_url) > 0 ? [1] : []
    content {
      redirect_all_requests_to = var.redirect_url
    }
  }

  dynamic website {
    for_each = length(var.redirect_url) > 0 ? [] : [1]
    content {
      index_document = var.index_document_default
      error_document = var.error_document_default
    }


  }

  cors_rule {
    allowed_origins = var.cors_allowed_origins
    allowed_methods = var.cors_allowed_methods
    allowed_headers = var.cors_allowed_headers
    expose_headers  = var.cors_expose_headers
    max_age_seconds = var.cors_max_age_seconds
  }

  logging {
    target_bucket = aws_s3_bucket.static_website_log_bucket.id
    target_prefix = format("%s/", var.site_name)
  }

  tags = merge({ "Name" = local.bucket_name, "Site Name" = var.site_name }, var.s3_tags, var.module_tags)
}

resource "aws_s3_bucket" "static_website_log_bucket" {
  bucket = local.logging_bucket_name
  acl    = "log-delivery-write"

  tags = merge({ "Name" = local.logging_bucket_name, "Site Name" = var.site_name }, var.s3_tags, var.module_tags)
}

resource "aws_s3_bucket_object" "config_file" {
  key     = "config.json"
  bucket  = aws_s3_bucket.static_website.id
  content = jsonencode(var.site_config_values)
  acl     = "public-read"

  tags = merge({ "Site Name" = var.site_name }, var.module_tags)
}
