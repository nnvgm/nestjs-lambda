
variable "aws_profile" {
  type    = string
  default = "default"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "aws_accountnum" {
  type = string
}

variable "mongodb_uri" {
  type = string
}

variable "lambda_version" {
  type    = string
  default = "latest"
}
