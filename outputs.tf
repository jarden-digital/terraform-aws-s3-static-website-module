output "s3_bucket_website_domain" {
  value = "${element(concat(aws_s3_bucket.static_website.*.website_domain, list("")), 0)}"
}

output "s3_bucket_website_endpoint" {
  value = "${element(concat(aws_s3_bucket.static_website.*.website_endpoint, list("")), 0)}"
}

output "s3_bucket_hosted_id" {
  value = "${element(concat(aws_s3_bucket.static_website.*.hosted_zone_id, list("")), 0)}"
}

output "cloudfront_url" {
  value = "${element(concat(aws_cloudfront_distribution.cdn.*.domain_name, list("")),0)}"
}

output "cloudfront_hosted_zone" {
  value = "${element(concat(aws_cloudfront_distribution.cdn.*.hosted_zone_id, list("")),0)}"
}
