variable "aws_profile" {
  type    = string
  default = "default"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "aws_accountnum" {
  type = string
}

variable "lambda_memory_size" {
  type    = number
  default = 1024
}
