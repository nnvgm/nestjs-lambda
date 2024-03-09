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
  # policy_json            = data.aws_iam_policy_document.allow_s3_access.json
  depends_on             = [aws_security_group.lambda_sg]

  s3_existing_package = {
    bucket = data.aws_s3_bucket.source_code_bucket.id
    key    = "nestjs-lambda/${var.lambda_version}/nestjs-lambda-${var.lambda_version}.zip"
  }

  environment_variables = {
    PORT        = 5000
    MONGODB_URI = var.mongodb_uri
  }

  allowed_triggers = {
    "ApiGateway" = {
      service    = "apigateway"
      source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_accountnum}:*"
    }
  }
}
