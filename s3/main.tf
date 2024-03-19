 provider "aws" {
     region = "us-east-1"
     shared_config_files      = ["/home/ubuntu/.aws/config"]
     shared_credentials_files = ["/home/ubuntu/.aws/credentials"]
     profile                  = "krishna"

 resource "aws_s3_bucket" "example" {
   bucket = "my-bukk-001"

   tags = {
     Name        = "My bucket"
     Environment = "Dev"
   }
}
