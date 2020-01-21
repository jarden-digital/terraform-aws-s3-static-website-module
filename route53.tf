resource "aws_route53_record" "static_website_url" {
  count   = var.create_custom_route53_record ? 1 : 0
  zone_id = var.zone_id
  name    = var.url
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
