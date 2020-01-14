module "static_website_example" {
  source = "../../"

providers = {
    aws = "aws"
  }

site_name      = "bundle"
site_namespace = "dev.example.com"

url = "frontend.uat.jarden.io"
certificate_arn = "arn:aws:acm:us-east-1:854489628483:certificate/bd28f825-8385-4ec7-8bbf-a25cb169db9b"

site_config_values = {
  "auth_url" = "www.google.com"
  "backend_url" = "www.aws.com"
}

cors_allowed_origins = ["*"]
cors_allowed_headers = [""]


}

provider "aws" {
  region = "${var.aws_region}"
}

variable "aws_region" {
  default = "ap-southeast-2"
}

output "website_domain" {
  value = "${module.static_website_example.s3_bucket_website_domain}"
}


output "website_endpoint" {
  value = "${module.static_website_example.s3_bucket_website_endpoint}"
}



output "website_hosted_id" {
  value = "${module.static_website_example.s3_bucket_hosted_id}"
}
