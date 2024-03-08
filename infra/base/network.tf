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
}

resource "aws_security_group" "mongodb_sg" {
  name        = "nestjs-lambda-example-mongodb-sg"
  description = "allow mongodb access"
  vpc_id      = module.vpc.vpc_id
  depends_on  = [module.vpc]
}

resource "aws_vpc_security_group_egress_rule" "egress_mongo_port_sg" {
  security_group_id = aws_security_group.mongodb_sg.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 27017
  to_port           = 27017
  ip_protocol       = "tcp"
  depends_on        = [aws_security_group.mongodb_sg]
}
