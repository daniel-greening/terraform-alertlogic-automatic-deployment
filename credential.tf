// Module that sets up an AWS automatic mode deployment in within professional scope
// shall also create a valid manual mode IAM role

locals {
  alertlogic_aws_accounts = {
    "integration"      = "948063967832"
    "cd-us-production" = "733251395267"
    "cd-uk-production" = "857795874556"
  }
  alertlogic_policies = {
    "automatic" = "${path.module}/internal/automatic_mode_policy.json"
    "manual"    = "${path.module}/internal/manual_mode_policy.json"
  }
}

resource "aws_iam_role" "iam_role" {
  assume_role_policy = data.aws_iam_policy_document.iam_policy_doc.json
}

resource "aws_iam_role_policy" "iam_policy" {
  policy = file(lookup(local.alertlogic_policies, var.alertlogic_deployment_mode))
  role = aws_iam_role.iam_role.id
}

data "aws_iam_policy_document" "iam_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [var.alertlogic_account_id]
    }
    principals {
      type        = "AWS"
      identifiers = [lookup(local.alertlogic_aws_accounts, var.alertlogic_stack)]
    }
    effect = "Allow"
  }
  version = "2012-10-17"
}

resource "alertlogic_credential" "discover_credential" {
  account_id  = var.alertlogic_account_id
  name        = "dgreening-terraform-credential1"
  secret_type = "aws_iam_role"
  secret_arn  = aws_iam_role.iam_role.arn
}
