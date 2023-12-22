variable "application_name" {
  description = "The display name for the application (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
  nullable    = false
  validation {
    condition     = length(var.application_name) > 2
    error_message = "The application name must have 3 or more characters"
  }
}

variable "create_application_password" {
  description = "Referecen: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password"
  type        = bool
  default     = false
}

variable "federated_identities" {
  type = map(object({
    description = string
    audiences   = list(string)
    issuer      = string
    subject     = string
  }))
  default     = {}
  description = "Reference: https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential"
}
