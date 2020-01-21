locals {
  bucket_name = format("%s-%s.%s", var.site_name, "artifactory", var.namespace)
}

resource "aws_s3_bucket" "artifactory" {
  bucket = local.bucket_name
  acl    = "private"

  force_destroy = var.force_destroy

  tags = merge(map("Name", local.bucket_name), map("Site Name", var.site_name), var.tags)
}
