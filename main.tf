terraform {

  required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "~> 4.0"

    }

  }

}

provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_route53_record" "root_domain" {
  zone_id = var.hosted_zone_id
  name    = var.root_domain
  type    = "A"

  alias {
    name                   = module.cdn.root_cdn.domain_name
    zone_id                = module.cdn.root_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

module "cdn" {
  source      = "./modules/cdn"
  root_domain = var.root_domain
  aws_region  = var.aws_region
}


module "s3" {
  source      = "./modules/s3"
  root_domain = var.root_domain
  root_cdn    = module.cdn.root_cdn
}
