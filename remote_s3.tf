terraform {
  backend "s3" {
    bucket = "chao-frontend-tfstate"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}