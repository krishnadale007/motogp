resource "aws_instance" "my_instance" {
  instance_count = var.instance_count
  ami           = var.image_id # us-west-2
  instance_type = var.instance_type
  vpc_security_group_ids = var.sg_ids
  key_name = var.key_name
  tags = {
    Name = ${var.project}-instance
    enviorment = var.enviorment
  }
  subnet_id = var.subnet_id
}