resource "tls_private_key" "rsa-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "tf-key-pair" {
  key_name   = "tf-key-pair"
  public_key = tls_private_key.rsa-key.public_key_openssh
}
resource "local_file" "tf-key" {
  content  = tls_private_key.rsa-key.private_key_pem
  filename = "tf-key-pair.pem"
}

resource "aws_instance" "bastion" {
  ami                         = var.AMI
  instance_type               = var.INSTANCE_TYPE
  key_name                    = "tf-key-pair"
  subnet_id                   = var.PUB_SUBNET_ID
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.security_group1.id]
  user_data                   = data.template_cloudinit_config.usrdata-script.rendered
  tags = {
    Name = "bastion"
  }
}