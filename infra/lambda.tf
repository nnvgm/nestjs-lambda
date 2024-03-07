locals {
  nestjs_lambda_function_name = "nestjs_lambda"
}

data "aws_iam_policy_document" "nestjs_lambda_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "nestjs_lambda_role" {
  name               = "nestjs_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.nestjs_lambda_policy.json
}

resource "aws_lambda_function" "nestjs_lambda" {
  function_name = local.nestjs_lambda_function_name
  role          = aws_iam_role.nestjs_lambda_role.arn
  handler       = "run.sh"
  runtime       = "nodejs18.x"
  layers        = ["arn:aws:lambda:${var.aws_region}:753240598075:layer:LambdaAdapterLayerX86:20"]
  memory_size   = var.lambda_memory_size

  environment {
    variables = {
      AWS_REGION              = var.aws_region
      PORT                    = "5000"
      AWS_LAMBDA_EXEC_WRAPPER = "/opt/bootstrap"
    }
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.nestjs_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_accountnum}:*"
}
