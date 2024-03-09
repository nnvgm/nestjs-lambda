data "aws_iam_policy_document" "allow_s3_access" {
  statement {
    effect    = "Allow"
    actions   = ["s3:Get*"]
    resources = ["*"]
  }
}
