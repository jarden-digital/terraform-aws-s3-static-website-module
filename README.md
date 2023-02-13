# Terraform-aws-s3-static-website Module

This module can be used to create a static website implementation using S3 and Cloudfront resources. The module can optionally add
a route53 entry to alias the Cloudfront with a custom domain.

The module requires a TLS certificate to be provisioned in the same AWS account in which the resources are being installed in.
Cloudfront only supports binding to certificates in the `us-east-1` region. A certificate arn is a required parameter for this module.

The module has been designed to support a Continuous Development/Deployment pattern. A config bucket object resource allows for the abstraction
of configuration elements from the bundle being served, allowing the bundle to become an immutable artifact. Configuration becomes a runtime concern, as opposed to a build time concern.

This module also has an additional and separate artifactory module - more information on what this module provides can be found in the [Artifactory README](artifactory/README.md)

### React client side routing support

In order to support React's client side routing implementation, you'll need to provide the following value for the `cloudfront_custom_errors` variable as follows

```
cloudfront_custom_errors = [
  {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
}]
```

The `response_page_path` (`/index.html` in this example) should match your static html file that invokes the React bundle. Further explanations for the settings can be found at https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#custom-error-response-arguments.

### Implementation patterns

This module is used to provide the infrastructure for both serving static content in a way that creates pipeline building blocks that allows users to easily construct a pipeline to provide continuous delivery patterns. An example pipeline is shown below:

Build/Test/Package -> Copy to Artifactory (S3 Bucket) -> Copy to Module implementation (e.g. UAT) -> Promote to Module implementation (e.g. PROD)

## ADR's

This module includes an Architectural Decision Register (ADR's) as represented by [the first adr](docs/adr/0001-record-architecture-decisions.md). All ADR's are listed [here](docs/adr/toc.md).

## Terraform version support

This repo supports version 0.12 and above of Terraform.

## Contributions

All contributions are accepted, details on how to contribute can be found in [contrib.md](contrib.md).

---

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| certificate_arn | The arn of the certificate to be used for TLS connections. The certificate must be in the same account as the cloudfront resource. | `any` | n/a | yes |
| cors_allowed_headers | Specifies which headers are allowed. | `list(string)` | n/a | yes |
| cors_allowed_origins | A list of allowed CORS origins. | `list(string)` | n/a | yes |
| namespace | A namespace that is appended to the `site_name` variable. This minimises S3 bucket naming collisions. | `any` | n/a | yes |
| site_name | The name of the static website or js bundle to be hosted by the S3 bucket. This will be the bucket name prefix. | `any` | n/a | yes |
| url | The custom URL to access the site. Must match the certificate name to provide a valid TLS connection. | `any` | n/a | yes |
| cloudfront_allowed_methods | Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD",<br>  "OPTIONS"<br>]</pre> | no |
| cloudfront_cached_methods | Controls whether CloudFront caches the response to requests using the specified HTTP methods. | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| cloudfront_custom_errors | A map of custom error settings for the CloudFront Distribution | <pre>list(object({<br>    error_caching_min_ttl = number<br>    error_code            = number<br>    response_code         = number<br>    response_page_path    = string<br>  }))</pre> | `[]` | no |
| cloudfront_tags | Additional tags to be added to all cloudfront resources. | `map(string)` | `{}` | no |
| comment | A comment for the Cloudfront distribution resource | `string` | `""` | no |
| cors_allowed_methods | Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD. Defaults to `GET`, `PUT`, `POST`. | `list(string)` | <pre>[<br>  "GET",<br>  "PUT",<br>  "POST"<br>]</pre> | no |
| cors_expose_headers | Specifies expose header in the response. Defaults to `ETag`. | `list(string)` | <pre>[<br>  "ETag"<br>]</pre> | no |
| cors_max_age_seconds | Specifies time in seconds that browser can cache the response for a preflight request. Defaults to 1 hour. | `number` | `3600` | no |
| create_custom_route53_record | Determines if a route53 alias record should be created that matches the `url` variable. Default is false. | `bool` | `false` | no |
| default_ttl | The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header. Defaults to 1 hour. | `number` | `3600` | no |
| enable_cdn_compression | Select whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header. CloudFront compresses files of certain types for both Amazon S3 and custom origins. Default is `true`. | `bool` | `true` | no |
| error_document_default | The default error html file. Defaults to `error.html`. | `string` | `"error.html"` | no |
| index_document_default | The default html file. Defaults to `index.html`. | `string` | `"index.html"` | no |
| max_ttl | The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of Cache-Control max-age, Cache-Control s-maxage, and Expires headers. Defaults to 7 days. | `number` | `604800` | no |
| min_ttl | The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to 0 seconds. | `number` | `0` | no |
| module_tags | Additional tags that are added to all resources in this module. | `map(string)` | `{}` | no |
| price_class | The price class for this distribution. One of `PriceClass_All`, `PriceClass_200`, `PriceClass_100`. | `string` | `"PriceClass_All"` | no |
| redirect_url | A hostname to redirect all website requests for this bucket to. Hostname can optionally be prefixed with a protocol (`http://` or `https://`) to use when redirecting requests. The default is the protocol that is used in the original request. If set will override the `index_document_default` variable | `string` | `""` | no |
| s3_tags | Additional tags to be added to all s3 resources. | `map(string)` | `{}` | no |
| site_config_cache_control | The value of the `Cache-Control` header to be used for the site config file served from S3. | `string` | `null` | no |
| site_config_values | A map of js bundle configuration values required for a specific environment. | `map(any)` | `{}` | no |
| wait_for_deployment | If enabled, the resource will wait for the distribution status to change from `InProgress` to `Deployed`. Setting this to `false` will skip the process. Default: `true`. | `bool` | `true` | no |
| zone_id | The zone id of the hosted zone to create the alias record in. Used only when `create_custom_route53_record` is set to `true`. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudfront_hosted_zone | The hosted zone id of the Cloudfront Distribution |
| cloudfront_url | The URL for the Cloudfront Distribution - used to set the alias for the custom domain. |
| s3_bucket_domain_name | The regional domain of the s3 web site bucket. |
| s3_bucket_hosted_id | The hosted_id s3 web site bucket. |
| s3_bucket_website_endpoint | The endpoint of the s3 web site bucket. |
<!-- END_TF_DOCS -->
