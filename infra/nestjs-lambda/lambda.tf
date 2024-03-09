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
  memory_size            = 1024
  timeout                = 30
  create_package         = false
  lambda_role            = aws_iam_role.lambda_role.arn
  create_role            = false
  depends_on             = [aws_security_group.lambda_sg, aws_iam_role.lambda_role]

  s3_existing_package = {
    bucket = data.aws_s3_bucket.source_code_bucket.id
    key    = "nestjs-lambda/${var.lambda_version}/nestjs-lambda-${var.lambda_version}.zip"
  }

  environment_variables = {
    PORT                    = 5000
    MONGODB_URI             = var.mongodb_uri
    AWS_LAMBDA_EXEC_WRAPPER = "/opt/bootstrap"
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.nestjs_lambda_function.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_accountnum}:*"
}
