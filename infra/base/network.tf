data "aws_availability_zones" "azs" {
  state = "available"
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "5.5.3"
  name               = "shared-vpc"
  cidr               = var.vpc_cidr
  azs                = data.aws_availability_zones.azs.zone_ids
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_nat_gateway = true

  private_subnet_tags = {
    "type" = "private"
  }
  public_subnet_tags = {
    "type" = "public"
  }
}

resource "aws_security_group" "mongodb_sg" {
  name        = "nestjs-lambda-example-mongodb-sg"
  description = "allow mongodb access"
  vpc_id      = module.vpc.vpc_id
  depends_on  = [module.vpc]
}

resource "aws_security_group_rule" "ingress_mongodb_allow_bastion" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  security_group_id        = aws_security_group.mongodb_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
  depends_on               = [aws_security_group.mongodb_sg, aws_security_group.bastion_sg]
}

resource "aws_security_group_rule" "egress_mongo_port_sg" {
  type              = "egress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  cidr_blocks       = concat([var.vpc_cidr], var.whitelist_ips)
  security_group_id = aws_security_group.mongodb_sg.id
  depends_on        = [aws_security_group.mongodb_sg]
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "allow access from the whitelist ips"
  vpc_id      = module.vpc.vpc_id
  depends_on  = [module.vpc]
}

resource "aws_security_group_rule" "egress_bastion_sg" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
  depends_on        = [aws_security_group.bastion_sg]
}

resource "aws_security_group_rule" "ingress_mongo_bastion_sg" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  cidr_blocks       = var.whitelist_ips
  security_group_id = aws_security_group.bastion_sg.id
  depends_on        = [aws_security_group.bastion_sg]
}

resource "aws_security_group_rule" "ingress_ssh_bastion_sg" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.whitelist_ips
  security_group_id = aws_security_group.bastion_sg.id
  depends_on        = [aws_security_group.bastion_sg]
}
