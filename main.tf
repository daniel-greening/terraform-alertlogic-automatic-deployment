// Module that sets up an AWS SIEMLESS deployment
// Resources created:
//   - AWS IAM role for the deployment to use in the provided aws account
//   - Alert Logic credential to store the generated IAM role
//   - Alert Logic deployment linking to the provided aws account

// Used to retrieve the aws account_id of the authenticated provider of the root module
data "aws_caller_identity" "current" {}

resource "alertlogic_deployment" "manual_deployment" {
  account_id    = var.alertlogic_account_id
  name          = "aa-terraform-test"
  platform_type = "aws"
  platform_id   = data.aws_caller_identity.current.account_id
  mode          = var.alertlogic_deployment_mode
  depends_on = ["alertlogic_credential.discover_credential"]

  scope_include {
    type = "vpc"
    key = "/aws/${var.aws_region}/vpc/${var.aws_vpc_id}"
    policy_id = "D12D5E67-166C-474F-87AA-6F86FC9FB9BC"
  }

  credential {
      id = alertlogic_credential.discover_credential.id
      purpose = "discover"
  }
  cloud_defender_location_id = var.alertlogic_datacenter
  cloud_defender_enabled = false
}
