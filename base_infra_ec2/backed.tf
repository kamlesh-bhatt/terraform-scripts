
terraform {
  backend "s3" {
    bucket = "kb-terraformstate"
    region = "ap-southeast-1"
    key = "terraformec2.tfstate"
    access_key = "your access keys here"
    secret_key = "your secret here"
  }
}