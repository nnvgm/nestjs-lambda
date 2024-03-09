resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = "bastion-sshkey"
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_secretsmanager_secret" "bastion_ssh_key" {
  name_prefix = "example/bastion-sshkey"
  description = "SSH Key for bastion host"
}

resource "aws_secretsmanager_secret_version" "bastion_ssh_key" {
  secret_id = aws_secretsmanager_secret.bastion_ssh_key.id
  secret_string = jsonencode({
    "private_key" = base64encode(tls_private_key.key.private_key_pem),
    "public_key"  = base64encode(tls_private_key.key.public_key_openssh)
  })
}

module "bastion_host" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.6.1"
  name                        = "bastion-host"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.keypair.key_name
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  subnet_id                   = element(module.vpc.public_subnets, 0)
  associate_public_ip_address = true
  user_data                   = file("./scripts/bootstrap_bastion_host.sh")
  depends_on                  = [module.vpc, aws_key_pair.keypair, aws_security_group.bastion_sg]
}
