output "alertlogic_account_id" {
  value = var.alertlogic_account_id
}

output "alertlogic_deployment_id" {
  value = alertlogic_deployment.manual_deployment.id
}

output "alertlogic_credential_id" {
  value = alertlogic_credential.discover_credential.id
}

output "deployment_role_arn" {
  value = aws_iam_role.iam_role.arn
}
