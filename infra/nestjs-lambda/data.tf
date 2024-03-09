data "aws_vpc" "vpc" {
  cidr_block = "10.10.0.0/16"
}

data "aws_s3_bucket" "source_code_bucket" {
  bucket = "shared-source-code"
}

data "aws_security_group" "mongodb_sg" {
  name = "nestjs-lambda-example-mongodb-sg"
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:type"
    values = ["private"]
  }
}
