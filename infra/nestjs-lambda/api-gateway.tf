# module "api_gateway" {
#   source = "terraform-aws-modules/apigateway-v2/aws"

#   name          = "dev-http"
#   description   = "My awesome HTTP API Gateway"
#   protocol_type = "HTTP"
#   # Routes and integrations
#   integrations = {
#     "POST /" = {
#       lambda_arn             = "arn:aws:lambda:eu-west-1:052235179155:function:my-function"
#       payload_format_version = "2.0"
#       timeout_milliseconds   = 12000
#     }

#     "GET /some-route-with-authorizer" = {
#       integration_type = "HTTP_PROXY"
#       integration_uri  = "some url"
#       authorizer_key   = "azure"
#     }
#   }
# }
