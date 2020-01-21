module "static_website_artifactory_example" {
  source = "../"

  providers = {
    aws = "aws"
  }

  site_name = "bundle"
  namespace = "dev.example.com"
}

provider "aws" {
  region = "${var.aws_region}"
}

variable "aws_region" {
  default = "ap-southeast-2"
}

output "bucket_name" {
  value = "${module.static_website_artifactory_example.bucket_name}"
}
