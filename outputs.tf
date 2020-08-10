output "s3_bucket_domain_name" {
  description = "The regional domain of the s3 web site bucket."
  value       = aws_s3_bucket.static_website.bucket_regional_domain_name
}

output "s3_bucket_website_endpoint" {
  description = "The endpoint of the s3 web site bucket."
  value       = aws_s3_bucket.static_website.website_endpoint
}

output "s3_bucket_hosted_id" {
  description = "The hosted_id s3 web site bucket."
  value       = aws_s3_bucket.static_website.hosted_zone_id
}

output "cloudfront_url" {
  description = "The URL for the Cloudfront Distribution - used to set the alias for the custom domain."
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_hosted_zone" {
  description = "The hosted zone id of the Cloudfront Distribution"
  value       = aws_cloudfront_distribution.cdn.hosted_zone_id
}
