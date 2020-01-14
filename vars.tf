variable "site_name" {
  description = "The name of the static website or js bundle to be hosted by the S3 bucket. This will be the bucket name prefix."
}

variable "site_namespace" {
  description = "A namespace that is appended to the `site_name` variable. This minimises S3 bucket naming collisions."
}

variable "index_document_default" {
  description = "The default html file. Defaults to `index.html`."
  default     = "index.html"
}

variable "error_document_default" {
  description = "The default error html file. Defaults to `error.html`."
  default     = "error.html"
}

variable "cors_allowed_origins" {
  description = "A list of allowed CORS origins."
  type        = "list"
}

variable "cors_allowed_headers" {
  description = "Specifies which headers are allowed."
  type        = "list"
}

variable "cors_allowed_methods" {
  description = "Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD. Defaults to `GET`, `PUT`, `POST`."
  type        = "list"
  default     = ["GET", "PUT", "POST"]
}

variable "cors_expose_headers" {
  description = "Specifies expose header in the response. Defaults to `ETag`"
  type        = "list"
  default     = ["ETag"]
}

variable "cors_max_age_seconds" {
  description = "Specifies time in seconds that browser can cache the response for a preflight request. Defaults to 1 hour."
  default     = 3600
}

variable "enable_bucket_object_versioning" {
  description = "Determines if the bucket should version objects. Default is `false`."
  default     = false
}

variable "site_config_values" {
  description = "A map of js bundle configuration values required for a specific environment."
  type        = "map"
  default     = {}
}

variable "url" {
  description = "The url alias to access the bucket. Must match the certificate name to provide a TLS connection"
}

variable "cloudfront_allowed_methods" {
  description = " Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin."
  type        = "list"
  default     = ["GET", "HEAD", "OPTIONS"]
}

variable "cloudfront_cached_methods" {
  description = "Controls whether CloudFront caches the response to requests using the specified HTTP methods."
  type        = "list"
  default     = ["GET", "HEAD"]
}

variable "min_ttl" {
  description = "The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to 0 seconds."
  default     = 0
}

variable "default_ttl" {
  description = "The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header. Defaults to 1 hour."
  default     = 3600
}

variable "max_ttl" {
  description = "The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of Cache-Control max-age, Cache-Control s-maxage, and Expires headers. Defaults to 7 days."
  default     = 604800
}

variable "price_class" {
  description = "The price class for this distribution. One of `PriceClass_All`, `PriceClass_200`, `PriceClass_100`"
  default     = "PriceClass_All"
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from `InProgress` to `Deployed`. Setting this tofalse will skip the process. Default: `true`."
  default     = true
}


variable "enable_cdn_compression" {
  description = "Select whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header. CloudFront compresses files of certain types for both Amazon S3 and custom origins. Default is `true`."
  default     = true
}

variable "certificate_arn" {
  description = "The arn of the certificate to be used for TLS connections. The certificate must be in the same account as the cloudfront resource."
}

variable "create_custom_route53_record" {
  description = "Determines if a route53 alias record should be created that matches the `url` variable. Default is false."
  default     = false
}

variable "zone_id" {
  description = "The zone id of the hosted zone to create the alias record in. Used only when `create_custom_route53_record` is set to `true`. "
  default     = ""
}