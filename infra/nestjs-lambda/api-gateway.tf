module "api_gateway" {
  source                 = "terraform-aws-modules/apigateway-v2/aws"
  version                = "3.1.1"
  name                   = "nestjs-lambda-http"
  protocol_type          = "HTTP"
  create_api_domain_name = false

  # domain_name                 = local.domain_name
  # domain_name_certificate_arn = module.acm.acm_certificate_arn

  integrations = {
    "ANY /{proxy+}" = {
      lambda_arn             = module.nestjs_lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 30000
    }
  }
}
