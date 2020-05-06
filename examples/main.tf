provider aws {
  profile = "collect"
  region = "us-east-2"
}

provider alertlogic {
  endpoint = "https://api.product.dev.alertlogic.com"
}

variable "alertlogic_account_id" {
  description = "Alert Logic account ID to deploy under"
}

module manual_deployment {
  source = "git::ssh://git@algithub.pd.alertlogic.net/daniel-greening/terraform-alertlogic-automatic-deployment.git"
  alertlogic_account_id = var.alertlogic_account_id
}
