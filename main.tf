// Module that sets up an AWS automatic mode deployment in within professional scope
// shall also create a valid manual mode IAM role
// is hard-coded to integration stack for now...

// Used to retrieve the aws account_id of the authenticated provider
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "automatic_mode" {
  assume_role_policy = data.aws_iam_policy_document.automatic_mode.json
}

resource "aws_iam_role_policy" "manual_mode" {
  policy = file("${path.module}/internal/automatic_mode_policy.json")
  role = aws_iam_role.automatic_mode.id
}

data "aws_iam_policy_document" "automatic_mode" {
  statement {
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [var.al_account_id]
    }
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::948063967832:root"] // Integration
    }
    effect = "Allow"
  }
  version = "2012-10-17"
}

resource "alertlogic_credential" "automatic_credential" {
  account_id  = var.al_account_id
  name        = "dgreening-terraform-credential1"
  secret_type = "aws_iam_role"
  secret_arn  = aws_iam_role.automatic_mode.arn
}

resource "alertlogic_deployment" "manual_deployment" {
  account_id    = var.al_account_id
  name          = "aa-terraform-test"
  platform_type = "aws"
  platform_id   = data.aws_caller_identity.current.account_id
  mode          = "automatic"
  depends_on = ["alertlogic_credential.automatic_credential"]

  scope_include {
    type = "vpc"
    key = "/aws/${var.aws_region}/vpc/${var.aws_vpc_id}"
    policy_id = "D12D5E67-166C-474F-87AA-6F86FC9FB9BC"
  }

  credential {
      id = alertlogic_credential.automatic_credential.id
      purpose = "discover"
  }
  cloud_defender_location_id = "defender-us-ashburn"
  cloud_defender_enabled = false
}
