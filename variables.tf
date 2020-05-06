variable alertlogic_account_id {
  type = string
  description = "The Alert Logic account ID to provision under."
}

variable alertlogic_datacenter {
  type = string
  description = "The Alert Logic Datacenter the provided account is provisioned in. Defaults to defender-us-ashburn"
  default = "defender-us-ashburn"
}

variable alertlogic_deployment_mode {
  type = string
  description = "The deployment mode to use for the created deployment. Either 'automatic' or 'manual'"
  default = "manual"
}

variable alertlogic_stack {
  type = string
  description = "The Alert Logic stack to provision resources under. Either 'integration', 'cd-us-production' or 'cd-uk-production'"
  default = "integration"
}
