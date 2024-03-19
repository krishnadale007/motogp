provider "aws" {
    region = var.region
    shared_config_files      = ["/home/ubuntu/.aws/config"]
    shared_credentials_files = ["/home/ubuntu/.aws/credentials"]
    profile                  = "krishna"
}

terraform {
  backend "s3" {
    bucket = "prod-terraform.tfstate-b20"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-b20"
  }
}

# now we are calling the module from that folder

module "my_vpc_module" {
  source = "./modules/vpc"
  project = var.project
  vpc_cidr = var.vpc_cidr
  enviorment = var.enviorment
  private_subnet_cidr = var.private_subnet_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

# anyway: here also we can create resource (security group)
resource "aws_security_group" "my_sg" {
  name        = "${var.project}-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.my_vpc_module.vpc_id

  ingress = {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_block = ["0.0.0.0/0"]
  }

  ingress = {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_block = ["0.0.0.0/0"]
  }

  ingress = {
  protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_block = ["0.0.0.0/0"]
  }

    egress = {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_block = ["0.0.0.0/0"]
  }

  depends_on = [ 
    module.my_vpc_module
   ]
}


# Instance creating in public subnet by calling o/p
module "my_instance" {
  source = "./modules/instance"
  instance_cocount = var.instance_count
  ami = var.image_id
  instance_type = var.instance_type
  key_name = var.key_name
  project = var.project
  enviorment = var.enviorment
  subnet_id = module.my_vpc_module.public_subnet_id  # it will create from vpc when vpc will create & this id will only bounded with vpc directory if we want sg_id from vpc so we need to use the "output_block"
  sg_ids = [aws_security_group.my_sg.id]    
}

# # Instance creating in private subnet by calling o/p
# module "my_instance_private" {
#   source = "./modules/instance"
#   instance_cocount = var.instance_count
#   ami = var.image_id
#   instance_type = var.instance_type
#   key_name = var.key_name
#   project = var.project
#   enviorment = var.enviorment
#   subnet_id = module.my_vpc_module.private_subnet_id  # it will create from vpc when vpc will create & this id will only bounded with vpc directory if we want sg_id from vpc so we need to use the "output_block"
#   sg_ids = 
# }


  
}