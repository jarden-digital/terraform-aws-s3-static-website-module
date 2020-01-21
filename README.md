# Terraform-aws-s3-static-website Module

This module can be used to create a static website implementation using S3 and Cloudfront resources. The module can optionally add
a route53 entry to alias the Cloudfront with a custom domain.

The module requires a TLS certificate to be provisioned in the same AWS account in which the resources are being installed in.
Cloudfront only supports binding to certificates in the `us-east-1` region. A certificate arn is a required parameter for this module.

The module has been designed to support a Continuous Development/Deployment pattern. A config bucket object resource allows for the abstraction
of configuration elements from the bundle being served, allowing the bundle to become an immutable artifact. Configuration becomes a runtime concern, as opposed to a build time concern.

This module also has an additional and separate artifactory module - more information on what this module provides can be found in the [Artifactory README](artifactory/README.md)

### Implementation patterns

This module is used to provide the infrastructure for both serving static content in a way that creates pipeline building blocks that allows users to easily construct a pipeline to provide continuous delivery patterns. An example pipeline is shown below:

Build/Test/Package    ->    Copy to Artifactory (S3 Bucket)    ->    Copy to Module implementation (e.g. UAT)    ->    Promote to Module implementation (e.g. PROD)

## ADR's

This module includes an Architectural Decision Register (ADR's) as represented by [the first adr](docs/adr/0001-record-architecture-decisions.md). All ADR's are listed [here](docs/adr/toc.md).

## Terraform version support
This repo supports version 0.11 and 0.12 of Terraform. The implementation pattern is outlined in the following ADR [4. Dual support for Terraform version 0.11 and 0.12](docs/adr/0004-dual-support-for-terraform-version-0-11-and-0-12.md)

## Contributions
All contributions are accepted, details on how to contribute can be found in [contrib.md](contrib.md).

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.19 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| certificate\_arn | The arn of the certificate to be used for TLS connections. The certificate must be in the same account as the cloudfront resource. | `any` | n/a | yes |
| cors\_allowed\_headers | Specifies which headers are allowed. | `list(string)` | n/a | yes |
| cors\_allowed\_origins | A list of allowed CORS origins. | `list(string)` | n/a | yes |
| namespace | A namespace that is appended to the `site_name` variable. This minimises S3 bucket naming collisions. | `any` | n/a | yes |
| site\_name | The name of the static website or js bundle to be hosted by the S3 bucket. This will be the bucket name prefix. | `any` | n/a | yes |
| url | The custom URL to access the site. Must match the certificate name to provide a valid TLS connection. | `any` | n/a | yes |
| cloudfront\_allowed\_methods | Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD",<br>  "OPTIONS"<br>]<br></pre> | no |
| cloudfront\_cached\_methods | Controls whether CloudFront caches the response to requests using the specified HTTP methods. | `list(string)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]<br></pre> | no |
| cloudfront\_tags | Additional tags to be added to all cloudfront resources. | `map(any)` | `{}` | no |
| comment | A comment for the Cloudfront distribution resource | `string` | `""` | no |
| cors\_allowed\_methods | Specifies which methods are allowed. Can be GET, PUT, POST, DELETE or HEAD. Defaults to `GET`, `PUT`, `POST`. | `list(string)` | <pre>[<br>  "GET",<br>  "PUT",<br>  "POST"<br>]<br></pre> | no |
| cors\_expose\_headers | Specifies expose header in the response. Defaults to `ETag`. | `list(string)` | <pre>[<br>  "ETag"<br>]<br></pre> | no |
| cors\_max\_age\_seconds | Specifies time in seconds that browser can cache the response for a preflight request. Defaults to 1 hour. | `number` | `3600` | no |
| create\_custom\_route53\_record | Determines if a route53 alias record should be created that matches the `url` variable. Default is false. | `bool` | `false` | no |
| default\_ttl | The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header. Defaults to 1 hour. | `number` | `3600` | no |
| enable\_cdn\_compression | Select whether you want CloudFront to automatically compress content for web requests that include Accept-Encoding: gzip in the request header. CloudFront compresses files of certain types for both Amazon S3 and custom origins. Default is `true`. | `bool` | `true` | no |
| error\_document\_default | The default error html file. Defaults to `error.html`. | `string` | `"error.html"` | no |
| index\_document\_default | The default html file. Defaults to `index.html`. | `string` | `"index.html"` | no |
| max\_ttl | The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated. Only effective in the presence of Cache-Control max-age, Cache-Control s-maxage, and Expires headers. Defaults to 7 days. | `number` | `604800` | no |
| min\_ttl | The minimum amount of time that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated. Defaults to 0 seconds. | `number` | `0` | no |
| module\_tags | Additional tags that are added to all resources in this module. | `map(any)` | `{}` | no |
| price\_class | The price class for this distribution. One of `PriceClass_All`, `PriceClass_200`, `PriceClass_100`. | `string` | `"PriceClass_All"` | no |
| s3\_tags | Additional tags to be added to all s3 resources. | `map(any)` | `{}` | no |
| site\_config\_values | A map of js bundle configuration values required for a specific environment. | `map(any)` | `{}` | no |
| wait\_for\_deployment | If enabled, the resource will wait for the distribution status to change from `InProgress` to `Deployed`. Setting this to `false` will skip the process. Default: `true`. | `bool` | `true` | no |
| zone\_id | The zone id of the hosted zone to create the alias record in. Used only when `create_custom_route53_record` is set to `true`. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudfront\_hosted\_zone | The hosted zone id of the Cloudfront Distribution |
| cloudfront\_url | The URL for the Cloudfront Distribution - used to set the alias for the custom domain. |
| s3\_bucket\_hosted\_id | The hosted\_id s3 web site bucket. |
| s3\_bucket\_website\_domain | The domain of the s3 web site bucket. |
| s3\_bucket\_website\_endpoint | The endpoint of the s3 web site bucket. |

