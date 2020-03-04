output "s3_bucket_website_domain" {
  description = "The domain of the s3 web site bucket."
  value       = element(concat(aws_s3_bucket.static_website.*.website_domain, list("")), 0)
}

output "s3_bucket_website_endpoint" {
  description = "The endpoint of the s3 web site bucket."
  value       = element(concat(aws_s3_bucket.static_website.*.website_endpoint, list("")), 0)
}

output "s3_bucket_hosted_id" {
  description = "The hosted_id s3 web site bucket."
  value       = element(concat(aws_s3_bucket.static_website.*.hosted_zone_id, list("")), 0)
}

output "cloudfront_url" {
  description = "The URL for the Cloudfront Distribution - used to set the alias for the custom domain."
  value       = element(concat(aws_cloudfront_distribution.cdn.*.domain_name, list("")), 0)
}

output "cloudfront_hosted_zone" {
  description = "The hosted zone id of the Cloudfront Distribution"
  value       = element(concat(aws_cloudfront_distribution.cdn.*.hosted_zone_id, list("")), 0)
}
