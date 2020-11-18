resource "aws_cloudfront_distribution" "cdn" {
  origin {
    origin_id   = aws_s3_bucket.static_website.id
    domain_name = aws_s3_bucket.static_website.website_endpoint

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }



  aliases             = [var.url]
  wait_for_deployment = var.wait_for_deployment

  enabled             = true
  comment             = var.comment
  default_root_object = var.index_document_default


  dynamic "custom_error_response" {
    for_each = var.cloudfront_custom_errors
    content {
      error_caching_min_ttl = custom_error_response.value["error_caching_min_ttl"]
      error_code            = custom_error_response.value["error_code"]
      response_code         = custom_error_response.value["response_code"]
      response_page_path    = custom_error_response.value["response_page_path"]
    }
  }

  default_cache_behavior {
    allowed_methods  = var.cloudfront_allowed_methods
    cached_methods   = var.cloudfront_cached_methods
    target_origin_id = aws_s3_bucket.static_website.id
    compress         = var.enable_cdn_compression

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = var.index_document_default
    smooth_streaming       = false
    target_origin_id       = aws_s3_bucket.static_website.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "config.json"
    smooth_streaming       = false
    target_origin_id       = aws_s3_bucket.static_website.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }


  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    # Certificates for cloudfront _must_ be created in us-east-1
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  logging_config {
    bucket = aws_s3_bucket.static_website_log_bucket.bucket_domain_name
    prefix = "cloudfront/"
  }

  tags = merge({ "Name" = format("%s-cdn", var.site_name), "Site Name" = var.site_name }, var.cloudfront_tags, var.module_tags)
}
