resource "aws_security_group" "lambda_sg" {
  name   = "lambda-sg"
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_security_group_rule" "egress_https_lambda_sg" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = aws_security_group.lambda_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
  depends_on        = [aws_security_group.lambda_sg]
}

resource "aws_security_group_rule" "allow_lambda_access_mongo" {
  type                     = "ingress"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.mongodb_sg.id
  source_security_group_id = aws_security_group.lambda_sg.id
  depends_on               = [aws_security_group.lambda_sg]
}
