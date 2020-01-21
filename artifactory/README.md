# Static Website Artifactory

This Terraform module is provided as an additional component for those wanting to implement an static website artifactory. This artifactory is where versioned site artifacts can be stored and then copied to relevant s3-static-website module implementations. This provides one place where all content artifacts can be stored and referenced to aid in the creation of a continuous delivery/deployment pipeline.

This has been provided as an additional module to meet the architectural needs of a global module i.e. there will only ever be one module implementation of an artifactory, as opposed to n number of s3-static-website module implementations, where n is the number of environments. This module design also caters for cross AWS Account patterns.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| namespace | A namespace that is appended to the `site_name-artifactory.` variable. This minimises S3 bucket naming collisions. | string | n/a | yes |
| site\_name | The name of the static website or js bundle to be hosted by the S3 bucket. This will be the bucket name prefix. | string | n/a | yes |
| force\_destroy | Controls if all objects in a bucket should be deleted when destroying the bucket resource. If set to `false`, the bucket resource cannot be destroyed until all objects are deleted. Defaults to `true`. | string | `"true"` | no |
| tags | A map of additional tags to add to the artifactory resource. A name tag with the value `<site_name>-artifactory.<namespace>` is added by default. | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | The name of the artifactory bucket |

