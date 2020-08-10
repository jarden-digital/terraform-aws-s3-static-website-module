output "bucket_domain" {
  value = module.static_website_example.s3_bucket_domain_name
}

output "website_endpoint" {
  value = module.static_website_example.s3_bucket_website_endpoint
}

output "website_hosted_id" {
  value = module.static_website_example.s3_bucket_hosted_id
}

output "cloudfront_url" {
  value = module.static_website_example.cloudfront_url
}

output "cloudfront_hosted_zone" {
  value = module.static_website_example.cloudfront_hosted_zone
}
