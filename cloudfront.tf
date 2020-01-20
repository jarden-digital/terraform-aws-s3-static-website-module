resource "aws_cloudfront_distribution" "cdn" {
  origin {
    origin_id   = "${aws_s3_bucket.static_website.id}"
    domain_name = "${aws_s3_bucket.static_website.bucket_domain_name}"
  }

  aliases             = ["${var.url}"]
  wait_for_deployment = "${var.wait_for_deployment}"

  enabled             = true
  default_root_object = "${var.index_document_default}"

  default_cache_behavior {
    allowed_methods  = "${var.cloudfront_allowed_methods}"
    cached_methods   = "${var.cloudfront_cached_methods}"
    target_origin_id = "${aws_s3_bucket.static_website.id}"
    compress         = "${var.enable_cdn_compression}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl     = "${var.min_ttl}"
    default_ttl = "${var.default_ttl}"
    max_ttl     = "${var.max_ttl}"
  }

  price_class = "${var.price_class}"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    # Certificates for cloudfront _must_ be created in us-east-1
    acm_certificate_arn      = "${var.certificate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }

  logging_config {
    bucket = "${aws_s3_bucket.static_website_log_bucket.bucket_domain_name}"
    prefix = "cloudfront/"
  }
}
