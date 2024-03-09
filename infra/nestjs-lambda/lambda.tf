module "nestjs_lambda_function" {
  source                 = "terraform-aws-modules/lambda/aws"
  version                = "7.2.1"
  function_name          = "nestjs-lambda-example"
  handler                = "run.sh"
  runtime                = "nodejs18.x"
  architectures          = ["x86_64"]
  layers                 = ["arn:aws:lambda:${var.aws_region}:753240598075:layer:LambdaAdapterLayerX86:20"]
  vpc_security_group_ids = [aws_security_group.lambda_sg.id]
  vpc_subnet_ids         = data.aws_subnets.private_subnets.ids

  allowed_triggers = {
    "ApiGateway" = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_accountnum}:*"
    }
  }
}
