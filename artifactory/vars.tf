variable "site_name" {
  description = "The name of the static website or js bundle to be hosted by the S3 bucket. This will be the bucket name prefix."
}

variable "namespace" {
  description = "A namespace that is appended to the `site_name-artifactory.` variable. This minimises S3 bucket naming collisions."
}

variable "force_destroy" {
  description = "Controls if all objects in a bucket should be deleted when destroying the bucket resource. If set to `false`, the bucket resource cannot be destroyed until all objects are deleted. Defaults to `true`."
  default     = true
}

variable "tags" {
  description = "A map of additional tags to add to the artifactory resource. A name tag with the value `<site_name>-artifactory.<namespace>` is added by default."
  default     = {}
}
