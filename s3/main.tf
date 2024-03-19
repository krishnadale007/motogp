 provider "aws" {
     region = " var.region"
     shared_config_files      = ["/home/ubuntu/.aws/config"]
     shared_credentials_files = ["/home/ubuntu/.aws/credentials"]
     profile                  = "var.profile"

 resource "aws_s3_bucket" "example" {
   bucket = "my-bukk-001"

   tags = "var.tags"
}
